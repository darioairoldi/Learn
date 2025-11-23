import * as path from 'path';
import * as vscode from 'vscode';
import {
    LanguageClient,
    LanguageClientOptions,
    ServerOptions,
    TransportKind
} from 'vscode-languageclient/node';

let client: LanguageClient | undefined;
let statusBarItem: vscode.StatusBarItem;

export async function activate(context: vscode.ExtensionContext) {
    console.log('Metadata Watcher extension is activating...');

    // Create status bar item
    statusBarItem = vscode.window.createStatusBarItem(
        vscode.StatusBarAlignment.Right,
        100
    );
    statusBarItem.text = '$(sync~spin) Starting Metadata Watcher...';
    statusBarItem.tooltip = 'Metadata Watcher is starting';
    statusBarItem.show();
    context.subscriptions.push(statusBarItem);

    // Check if enabled
    const config = vscode.workspace.getConfiguration('metadataWatcher');
    if (!config.get<boolean>('enabled', true)) {
        statusBarItem.text = '$(circle-slash) Metadata Watcher Disabled';
        statusBarItem.tooltip = 'Metadata Watcher is disabled in settings';
        vscode.window.showInformationMessage('Metadata Watcher is disabled. Enable it in settings.');
        return;
    }

    // Find the server executable
    const serverPath = await findServerExecutable(config);
    if (!serverPath) {
        statusBarItem.text = '$(error) Metadata Watcher: Server Not Found';
        statusBarItem.tooltip = 'MetadataWatcher server executable not found. Run build script.';
        vscode.window.showErrorMessage(
            'Metadata Watcher server not found. Please run: .copilot/scripts/build-metadata-watcher.ps1',
            'Open Build Script'
        ).then(selection => {
            if (selection === 'Open Build Script') {
                const scriptPath = path.join(
                    vscode.workspace.workspaceFolders![0].uri.fsPath,
                    '.copilot',
                    'scripts',
                    'build-metadata-watcher.ps1'
                );
                vscode.window.showTextDocument(vscode.Uri.file(scriptPath));
            }
        });
        return;
    }

    console.log(`Found MetadataWatcher server at: ${serverPath}`);

    try {
        await startLanguageServer(context, serverPath);

        // Register commands
        context.subscriptions.push(
            vscode.commands.registerCommand('metadataWatcher.restart', async () => {
                await restartServer(context, serverPath);
            })
        );

        context.subscriptions.push(
            vscode.commands.registerCommand('metadataWatcher.showLogs', () => {
                showLogFile();
            })
        );

        statusBarItem.text = '$(check) Metadata Watcher';
        statusBarItem.tooltip = 'Metadata Watcher is active and monitoring file renames';
        statusBarItem.command = 'metadataWatcher.showLogs';

        vscode.window.showInformationMessage('Metadata Watcher is now active');
    } catch (error) {
        console.error('Failed to start Metadata Watcher:', error);
        statusBarItem.text = '$(error) Metadata Watcher: Failed';
        statusBarItem.tooltip = `Failed to start: ${error}`;
        vscode.window.showErrorMessage(`Failed to start Metadata Watcher: ${error}`);
    }
}

async function findServerExecutable(config: vscode.WorkspaceConfiguration): Promise<string | null> {
    // Check custom path first
    const customPath = config.get<string>('serverPath');
    if (customPath && await fileExists(customPath)) {
        return customPath;
    }

    // Check default locations
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0].uri.fsPath;
    if (!workspaceFolder) {
        return null;
    }

    const possiblePaths = [
        path.join(workspaceFolder, 'src', 'MetadataWatcher', 'bin', 'Release', 'net8.0', 'MetadataWatcher.exe'),
        path.join(workspaceFolder, 'src', 'MetadataWatcher', 'bin', 'Debug', 'net8.0', 'MetadataWatcher.exe'),
        path.join(workspaceFolder, '.copilot', 'bin', 'MetadataWatcher.exe'),
    ];

    for (const p of possiblePaths) {
        if (await fileExists(p)) {
            return p;
        }
    }

    return null;
}

async function fileExists(filePath: string): Promise<boolean> {
    try {
        await vscode.workspace.fs.stat(vscode.Uri.file(filePath));
        return true;
    } catch {
        return false;
    }
}

async function startLanguageServer(context: vscode.ExtensionContext, serverPath: string) {
    const workspaceFolder = vscode.workspace.workspaceFolders![0];

    // Server options
    const serverOptions: ServerOptions = {
        run: {
            command: serverPath,
            args: [],
            options: {
                cwd: workspaceFolder.uri.fsPath
            }
        },
        debug: {
            command: serverPath,
            args: [],
            options: {
                cwd: workspaceFolder.uri.fsPath
            }
        }
    };

    // Client options
    const clientOptions: LanguageClientOptions = {
        documentSelector: [
            { scheme: 'file', language: 'markdown' }
        ],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher('**/*.md')
        },
        workspaceFolder: workspaceFolder
    };

    // Create and start the client
    client = new LanguageClient(
        'metadataWatcher',
        'Metadata Watcher',
        serverOptions,
        clientOptions
    );

    await client.start();
    console.log('Metadata Watcher Language Server started');
}

async function restartServer(context: vscode.ExtensionContext, serverPath: string) {
    statusBarItem.text = '$(sync~spin) Restarting Metadata Watcher...';

    if (client) {
        await client.stop();
        client = undefined;
    }

    try {
        await startLanguageServer(context, serverPath);
        statusBarItem.text = '$(check) Metadata Watcher';
        vscode.window.showInformationMessage('Metadata Watcher restarted successfully');
    } catch (error) {
        statusBarItem.text = '$(error) Metadata Watcher: Failed';
        vscode.window.showErrorMessage(`Failed to restart Metadata Watcher: ${error}`);
    }
}

function showLogFile() {
    const logPath = path.join(
        process.env.LOCALAPPDATA || process.env.HOME || '',
        'MetadataWatcher',
        'logs',
        `watcher-${new Date().toISOString().split('T')[0].replace(/-/g, '')}.log`
    );

    vscode.window.showTextDocument(vscode.Uri.file(logPath)).then(
        () => { },
        () => {
            vscode.window.showErrorMessage(`Log file not found: ${logPath}`);
        }
    );
}

export async function deactivate() {
    if (client) {
        await client.stop();
    }
    statusBarItem.dispose();
    console.log('Metadata Watcher extension deactivated');
}
