# How to Convert YAML to JSON - Complete Guide

## ?? Table of Contents

- [?? Overview](#-overview)
- [?? Simple Solutions](#-simple-solutions)
  - [Online Converters](#online-converters)
  - [PowerShell Native Conversion](#powershell-native-conversion)
- [?? Command-Line Tools](#-command-line-tools)
  - [yq Tool (Recommended)](#yq-tool-recommended)
  - [Python-based Solutions](#python-based-solutions)
  - [Node.js Solutions](#nodejs-solutions)
- [?? Programming Solutions](#?-programming-solutions)
  - [PowerShell Script Integration](#powershell-script-integration)
  - [C# Application Development](#c-application-development)
  - [Python Automation](#python-automation)
- [??? Advanced Integration](#?-advanced-integration)
  - [Build Pipeline Integration](#build-pipeline-integration)
  - [Continuous Integration](#continuous-integration)
- [?? References](#-references)

---

## ?? **Overview**

Converting YAML to JSON is a common task in modern development workflows, especially when working with configuration files, CI/CD pipelines, and documentation systems. This guide covers practical solutions from simple online tools to enterprise-grade automation, based on real-world implementation experience.

**Why Convert YAML to JSON?**

- **Client-side consumption**: Browsers natively support JSON
- **API compatibility**: Most REST APIs use JSON format
- **Processing efficiency**: JSON parsing is typically faster
- **Size optimization**: JSON can be more compact for certain data structures

**Our Real-World Context:**

In our Quarto documentation project, we needed to convert `_quarto.yml` navigation structure to `navigation.json` for client-side consumption by our Related Pages feature. This practical requirement drove us to explore and implement several conversion approaches.

---

## ?? **Simple Solutions**

### Online Converters

**Best for:** One-time conversions, small files, learning purposes

**Pros:**
- ? No software installation required
- ? Instant results
- ? User-friendly interfaces
- ? Validation and error checking

**Cons:**
- ? Not suitable for automation
- ? Privacy concerns with sensitive data
- ? No version control integration
- ? Limited to small files

**How to Implement:**

1. **Choose a reputable online converter:**
   - YAML to JSON Converter (convertjson.com)
   - Online YAML Tools (onlineyamltools.com)
   - Code Beautify YAML to JSON

2. **Usage process:**
   ```
   1. Copy your YAML content
   2. Paste into the converter
   3. Click convert
   4. Copy the JSON result
   ```

### PowerShell Native Conversion

**Best for:** Windows environments, simple YAML structures, quick scripts

**Pros:**
- ? No external dependencies
- ? Built into Windows
- ? Good for automation
- ? Integrates with existing PowerShell workflows

**Cons:**
- ? Limited YAML parsing capabilities
- ? Windows-specific solution
- ? May not handle complex YAML features
- ? Requires PowerShell knowledge

**How to Implement:**

```powershell
# Basic YAML to JSON conversion using PowerShell
function Convert-YamlToJson {
    param(
        [string]$YamlFilePath,
        [string]$JsonOutputPath
    )
    
    # Install PowerShell-Yaml module if needed
    if (-not (Get-Module -ListAvailable -Name PowerShell-Yaml)) {
        Install-Module -Name PowerShell-Yaml -Force -Scope CurrentUser
    }
    
    # Import the module
    Import-Module PowerShell-Yaml
    
    # Read and convert
    $yamlContent = Get-Content $YamlFilePath -Raw
    $yamlObject = ConvertFrom-Yaml $yamlContent
    $jsonContent = $yamlObject | ConvertTo-Json -Depth 20
    
    # Save to file
    $jsonContent | Out-File -FilePath $JsonOutputPath -Encoding utf8 -NoNewline
    
    Write-Host "? Converted $YamlFilePath to $JsonOutputPath"
}

# Usage
Convert-YamlToJson -YamlFilePath "_quarto.yml" -JsonOutputPath "config.json"
```

---

## ?? **Command-Line Tools**

### yq Tool (Recommended)

**Best for:** Professional development, automation, complex YAML processing

Based on our real-world implementation experience, yq proved to be the most reliable solution for our navigation.json generation.

**Pros:**
- ? Extremely reliable and well-maintained
- ? Powerful query and transformation capabilities
- ? Cross-platform compatibility
- ? Excellent performance
- ? Active community and documentation

**Cons:**
- ? Requires installation/download
- ? Learning curve for advanced features
- ? Additional dependency to manage

**How to Implement:**

**Installation Options:**
```bash
# Via package managers
brew install yq                    # macOS
sudo apt install yq               # Ubuntu/Debian
choco install yq                  # Windows (Chocolatey)
scoop install yq                  # Windows (Scoop)

# Direct download (our approach)
# Download from https://github.com/mikefarah/yq/releases
```

**Basic Usage:**
```bash
# Simple YAML to JSON conversion
yq eval '.' input.yaml --output-format=json > output.json

# Extract specific sections (our use case)
yq eval '.website.sidebar.contents' _quarto.yml --output-format=json > navigation.json

# Complex transformations
yq eval '.website.sidebar | {"contents": .contents}' _quarto.yml --output-format=json
```

**Our Production Implementation:**
```powershell
# From our generate-navigation.ps1 script
$extractedContent = & $yqExecutable eval '.website.sidebar.contents' $quartoFile --output-format=json
$navigationStructure = @{
    contents = $extractedContent | ConvertFrom-Json
}
$navigationStructure | ConvertTo-Json -Depth 20 | Out-File -FilePath $navFile -Encoding utf8
```

### Python-based Solutions

**Best for:** Python environments, complex data processing, integration with data science workflows

**Pros:**
- ? Extensive ecosystem (PyYAML, ruamel.yaml)
- ? Powerful data manipulation capabilities
- ? Cross-platform compatibility
- ? Good for complex transformations

**Cons:**
- ? Requires Python installation
- ? Dependency management complexity
- ? Slower than native tools for simple conversions

**How to Implement:**

```python
import yaml
import json
import sys

def convert_yaml_to_json(yaml_file, json_file):
    """Convert YAML file to JSON file"""
    try:
        with open(yaml_file, 'r', encoding='utf-8') as f:
            yaml_data = yaml.safe_load(f)
        
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(yaml_data, f, indent=2, ensure_ascii=False)
        
        print(f"? Converted {yaml_file} to {json_file}")
        
    except Exception as e:
        print(f"? Error: {e}")
        sys.exit(1)

# Usage
if __name__ == "__main__":
    convert_yaml_to_json("_quarto.yml", "config.json")
```

**Advanced Python Solution:**
```python
# requirements.txt
# PyYAML>=6.0
# click>=8.0

import yaml
import json
import click
from pathlib import Path

@click.command()
@click.argument('input_file', type=click.Path(exists=True))
@click.argument('output_file', type=click.Path())
@click.option('--extract', help='Extract specific path (e.g., "website.sidebar")')
@click.option('--indent', default=2, help='JSON indentation')
def convert(input_file, output_file, extract, indent):
    """Convert YAML to JSON with optional path extraction"""
    
    with open(input_file, 'r') as f:
        data = yaml.safe_load(f)
    
    if extract:
        # Navigate to specific path
        keys = extract.split('.')
        for key in keys:
            data = data[key]
    
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=indent, ensure_ascii=False)
    
    click.echo(f"? Converted {input_file} to {output_file}")

if __name__ == '__main__':
    convert()
```

### Node.js Solutions

**Best for:** JavaScript ecosystems, web development workflows, npm-based projects

**Pros:**
- ? Fast execution
- ? Great for web development workflows
- ? Extensive package ecosystem
- ? JSON-native environment

**Cons:**
- ? Requires Node.js installation
- ? npm dependency management
- ? JavaScript-specific solution

**How to Implement:**

```javascript
// package.json dependencies: js-yaml

const fs = require('fs');
const yaml = require('js-yaml');

function convertYamlToJson(yamlFile, jsonFile) {
    try {
        const yamlContent = fs.readFileSync(yamlFile, 'utf8');
        const data = yaml.load(yamlContent);
        const jsonContent = JSON.stringify(data, null, 2);
        
        fs.writeFileSync(jsonFile, jsonContent, 'utf8');
        console.log(`? Converted ${yamlFile} to ${jsonFile}`);
        
    } catch (error) {
        console.error(`? Error: ${error.message}`);
        process.exit(1);
    }
}

// Usage
convertYamlToJson('_quarto.yml', 'config.json');
```

---

## ?? **Programming Solutions**

### PowerShell Script Integration

**Best for:** Windows environments, automation workflows, CI/CD integration

Our production implementation demonstrates a robust PowerShell-based solution with intelligent features:

**Advanced Features:**
- ? Timestamp-based smart regeneration
- ? Automatic tool download and management
- ? Error handling and validation
- ? Integration with build systems

**How to Implement:**

```powershell
# Enhanced version of our production script
function Convert-YamlToJsonAdvanced {
    param(
        [string]$SourceFile = "_quarto.yml",
        [string]$TargetFile = "navigation.json",
        [string]$ExtractPath = ".website.sidebar",
        [switch]$ForceRegenerate
    )
    
    # Smart regeneration check
    if (-not $ForceRegenerate -and (Test-Path $TargetFile)) {
        $sourceModified = (Get-Item $SourceFile).LastWriteTime
        $targetModified = (Get-Item $TargetFile).LastWriteTime
        
        if ($sourceModified -le $targetModified) {
            Write-Host "? $TargetFile is current, skipping generation"
            return
        }
    }
    
    # Tool management
    $yqExecutable = Get-YqTool
    
    # Conversion with validation
    try {
        $result = & $yqExecutable eval $ExtractPath $SourceFile --output-format=json
        
        # Validate JSON
        $null = $result | ConvertFrom-Json
        
        # Save with wrapper structure if needed
        $finalResult = @{ contents = ($result | ConvertFrom-Json) } | ConvertTo-Json -Depth 20
        $finalResult | Out-File -FilePath $TargetFile -Encoding utf8 -NoNewline
        
        Write-Host "? Generated $TargetFile successfully"
        
    } catch {
        Write-Error "? Conversion failed: $_"
        exit 1
    }
}

function Get-YqTool {
    $yqPath = "yq.exe"
    
    if (-not (Test-Path $yqPath)) {
        Write-Host "Downloading yq tool..."
        $yqUrl = "https://github.com/mikefarah/yq/releases/download/v4.40.5/yq_windows_amd64.exe"
        Invoke-WebRequest -Uri $yqUrl -OutFile $yqPath -UseBasicParsing
    }
    
    return ".\$yqPath"
}
```

### C# Application Development

**Best for:** .NET environments, enterprise applications, performance-critical scenarios

**Pros:**
- ? High performance
- ? Strong typing and error handling
- ? Excellent Visual Studio integration
- ? Deployment flexibility

**Cons:**
- ? Requires .NET development environment
- ? More complex than scripting solutions
- ? Compilation step required

**How to Implement:**

```csharp
// Package references: YamlDotNet, Newtonsoft.Json

using System;
using System.IO;
using YamlDotNet.Serialization;
using Newtonsoft.Json;

public class YamlToJsonConverter
{
    public static void ConvertFile(string yamlFile, string jsonFile)
    {
        try
        {
            // Read YAML
            string yamlContent = File.ReadAllText(yamlFile);
            
            // Parse YAML
            var deserializer = new DeserializerBuilder().Build();
            var yamlObject = deserializer.Deserialize(yamlContent);
            
            // Convert to JSON
            string jsonContent = JsonConvert.SerializeObject(yamlObject, Formatting.Indented);
            
            // Write JSON
            File.WriteAllText(jsonFile, jsonContent);
            
            Console.WriteLine($"? Converted {yamlFile} to {jsonFile}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"? Error: {ex.Message}");
            Environment.Exit(1);
        }
    }
    
    static void Main(string[] args)
    {
        if (args.Length != 2)
        {
            Console.WriteLine("Usage: converter.exe <input.yaml> <output.json>");
            return;
        }
        
        ConvertFile(args[0], args[1]);
    }
}
```

### Python Automation

**Best for:** Data processing workflows, scientific computing, complex transformations

**Advanced Implementation:**
```python
#!/usr/bin/env python3

import yaml
import json
import argparse
import logging
from pathlib import Path
from typing import Any, Dict, Optional

class YamlToJsonConverter:
    def __init__(self, log_level: str = "INFO"):
        logging.basicConfig(level=getattr(logging, log_level.upper()))
        self.logger = logging.getLogger(__name__)
    
    def convert_file(self, 
                    yaml_file: Path, 
                    json_file: Path,
                    extract_path: Optional[str] = None,
                    indent: int = 2) -> bool:
        """Convert YAML file to JSON with optional path extraction"""
        
        try:
            # Load YAML
            with open(yaml_file, 'r', encoding='utf-8') as f:
                data = yaml.safe_load(f)
            
            # Extract specific path if requested
            if extract_path:
                data = self._extract_path(data, extract_path)
            
            # Write JSON
            with open(json_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=indent, ensure_ascii=False)
            
            self.logger.info(f"? Converted {yaml_file} to {json_file}")
            return True
            
        except Exception as e:
            self.logger.error(f"? Conversion failed: {e}")
            return False
    
    def _extract_path(self, data: Dict[str, Any], path: str) -> Any:
        """Extract data from nested dictionary using dot notation"""
        keys = path.split('.')
        result = data
        
        for key in keys:
            if isinstance(result, dict) and key in result:
                result = result[key]
            else:
                raise KeyError(f"Path '{path}' not found in YAML data")
        
        return result

def main():
    parser = argparse.ArgumentParser(description='Convert YAML to JSON')
    parser.add_argument('input', help='Input YAML file')
    parser.add_argument('output', help='Output JSON file')
    parser.add_argument('--extract', help='Extract specific path (e.g., "website.sidebar")')
    parser.add_argument('--indent', type=int, default=2, help='JSON indentation')
    parser.add_argument('--log-level', default='INFO', help='Logging level')
    
    args = parser.parse_args()
    
    converter = YamlToJsonConverter(args.log_level)
    success = converter.convert_file(
        Path(args.input),
        Path(args.output),
        args.extract,
        args.indent
    )
    
    exit(0 if success else 1)

if __name__ == '__main__':
    main()
```

---

## ??? **Advanced Integration**

### Build Pipeline Integration

**Best for:** Automated workflows, CI/CD pipelines, enterprise environments

Our Quarto project demonstrates build pipeline integration:

**GitHub Actions Integration:**
```yaml
# .github/workflows/convert-config.yml
name: Convert YAML to JSON

on:
  push:
    paths:
      - '_quarto.yml'
      - 'config/**/*.yml'

jobs:
  convert:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Convert Configuration
        shell: pwsh
        run: |
          # Our production conversion script
          powershell -ExecutionPolicy Bypass -File scripts/generate-navigation.ps1
          
      - name: Commit Changes
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add navigation.json
          git commit -m "Auto-update navigation.json" || exit 0
          git push
```

**Pre-render Hook Integration:**
```yaml
# _quarto.yml
project:
  pre-render: 
    - powershell -ExecutionPolicy Bypass -File scripts/generate-navigation.ps1
```

### Continuous Integration

**Advanced CI/CD Integration:**

```yaml
# Azure DevOps Pipeline
trigger:
  paths:
    include:
      - config/*.yml
      - _quarto.yml

stages:
- stage: Convert
  jobs:
  - job: YamlToJson
    pool:
      vmImage: 'windows-latest'
    steps:
    - powershell: |
        # Install yq if not available
        if (-not (Get-Command yq -ErrorAction SilentlyContinue)) {
          $yqUrl = "https://github.com/mikefarah/yq/releases/download/v4.40.5/yq_windows_amd64.exe"
          Invoke-WebRequest -Uri $yqUrl -OutFile "yq.exe"
        }
        
        # Convert all YAML files to JSON
        Get-ChildItem -Path "config" -Filter "*.yml" | ForEach-Object {
          $jsonFile = $_.FullName -replace '\.yml$', '.json'
          .\yq.exe eval '.' $_.FullName --output-format=json > $jsonFile
        }
      displayName: 'Convert YAML to JSON'
    
    - publish: $(System.DefaultWorkingDirectory)
      artifact: converted-configs
```

---

## ?? **References**

### Official Documentation
- **[yq Documentation](https://mikefarah.gitbook.io/yq/)** - Complete guide to the yq command-line YAML processor
- **[YAML Specification](https://yaml.org/spec/1.2/spec.html)** - Official YAML 1.2 specification
- **[JSON Specification](https://www.json.org/)** - Official JSON format specification

### Tools and Libraries
- **[yq GitHub Repository](https://github.com/mikefarah/yq)** - Source code and releases for yq tool
- **[PyYAML Documentation](https://pyyaml.org/wiki/PyYAMLDocumentation)** - Python YAML parsing library
- **[YamlDotNet](https://github.com/aaubry/YamlDotNet)** - .NET YAML parsing library
- **[js-yaml](https://github.com/nodeca/js-yaml)** - JavaScript YAML parsing library

### PowerShell Resources
- **[PowerShell-Yaml Module](https://github.com/cloudbase/powershell-yaml)** - PowerShell YAML processing
- **[PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)** - Official PowerShell documentation

### Integration Guides
- **[GitHub Actions Documentation](https://docs.github.com/en/actions)** - Workflow automation
- **[Quarto Pre-render Hooks](https://quarto.org/docs/projects/scripts.html)** - Build system integration
- **[Azure DevOps Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/)** - CI/CD automation

---

**Next Steps:**
- Review the dedicated appendix files for detailed tool information and advanced techniques
- Choose the approach that best fits your specific requirements and environment
- Consider starting with simple solutions and evolving to more complex ones as needed