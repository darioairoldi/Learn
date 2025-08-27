# Appendix B: Advanced YAML to JSON Conversion Techniques

## Production Implementation Details

### Our Quarto Navigation System

This appendix contains detailed technical information about our real-world implementation for converting Quarto's `_quarto.yml` navigation structure to JSON for client-side consumption.

#### Complete PowerShell Implementation

```powershell
# Complete production script: scripts/generate-navigation.ps1

# Generate navigation.json from _quarto.yml (only when needed)
Write-Host "Checking navigation.json status..."

# Smart timestamp-based regeneration
$shouldGenerate = $false
$quartoFile = "_quarto.yml"
$navFile = "navigation.json"

if (-not (Test-Path $quartoFile)) {
    Write-Warning "_quarto.yml not found - cannot generate navigation.json"
    exit 1
}

if (-not (Test-Path $navFile)) {
    Write-Host "navigation.json does not exist - will generate"
    $shouldGenerate = $true
} else {
    $quartoModified = (Get-Item $quartoFile).LastWriteTime
    $navModified = (Get-Item $navFile).LastWriteTime
    
    if ($quartoModified -gt $navModified) {
        Write-Host "navigation.json is older than _quarto.yml - will regenerate"
        $shouldGenerate = $true
    } else {
        Write-Host "navigation.json is up to date - skipping generation"
        $shouldGenerate = $false
    }
}

if (-not $shouldGenerate) {
    Write-Host "? navigation.json is current, no action needed"
    exit 0
}

Write-Host "Generating navigation.json..."

# Automatic yq tool management
$yqPath = Get-Command yq -ErrorAction SilentlyContinue
if (-not $yqPath) {
    $yqVersion = "v4.40.5"
    $yqUrl = "https://github.com/mikefarah/yq/releases/download/$yqVersion/yq_windows_amd64.exe"
    
    Write-Host "Downloading yq..."
    try {
        Invoke-WebRequest -Uri $yqUrl -OutFile "yq.exe" -UseBasicParsing
        $yqExecutable = ".\yq.exe"
    } catch {
        Write-Error "Failed to download yq: $_"
        exit 1
    }
} else {
    $yqExecutable = "yq"
}

# Conversion with validation and error handling
Write-Host "Extracting navigation structure from _quarto.yml..."
try {
    # Extract sidebar contents using yq
    $extractedContent = & $yqExecutable eval '.website.sidebar.contents' $quartoFile --output-format=json
    
    # Wrap in expected structure for client-side consumption
    $navigationStructure = @{
        contents = $extractedContent | ConvertFrom-Json
    }
    
    # Convert to JSON with proper formatting
    $navigationStructure | ConvertTo-Json -Depth 20 | Out-File -FilePath $navFile -Encoding utf8 -NoNewline
    
    # Validate generated JSON
    $content = Get-Content $navFile -Raw | ConvertFrom-Json
    Write-Host "? navigation.json generated successfully with $($content.contents.Count) sections"
    
    # Synchronize timestamps to prevent unnecessary future regeneration
    $quartoTime = (Get-Item $quartoFile).LastWriteTime
    (Get-Item $navFile).LastWriteTime = $quartoTime
    
    Write-Host "? navigation.json is ready and versioned for commit"
    
} catch {
    Write-Warning "? Failed to generate or validate navigation.json: $_"
    Write-Host "Creating fallback navigation.json..."
    '{"contents": []}' | Out-File -FilePath $navFile -Encoding utf8 -NoNewline
    exit 1
}
```

#### Integration with Quarto Build System

**Pre-render Hook Configuration:**
```yaml
# _quarto.yml integration
project:
  type: website
  output-dir: docs
  pre-render: 
    - powershell -ExecutionPolicy Bypass -File scripts/generate-navigation.ps1
  render:
    - "*.qmd"
    - "*.md"
    - "*/README.md"
    - "**/README.md"
    - "**/SUMMARY.md"
    - "**/*.md"
```

**Client-side Integration:**
```javascript
// _includes/right-nav.html - Related Pages functionality
document.addEventListener('DOMContentLoaded', function() {
    // Load navigation configuration
    async function loadNavigationConfig() {
        try {
            let navUrl = window.location.href.includes('darioairoldi.github.io/Learn') 
                ? 'https://darioairoldi.github.io/Learn/navigation.json'
                : window.location.origin + '/navigation.json';
            
            const response = await fetch(navUrl);
            
            if (response.ok && response.headers.get('content-type')?.includes('application/json')) {
                navigationConfig = await response.json();
                renderRelatedPages();
            } else {
                console.log('Navigation config not available, using DOM parsing');
                renderRelatedPages(); // Fallback to DOM parsing
            }
        } catch (error) {
            console.log('Navigation config error:', error.message);
            renderRelatedPages(); // Fallback to DOM parsing
        }
    }
    
    // Initialize Related Pages widget
    createCustomRightNav();
    loadNavigationConfig();
});
```

## Advanced Error Handling Patterns

### Robust PowerShell Error Management

```powershell
function Convert-YamlToJsonRobust {
    param(
        [Parameter(Mandatory)]
        [string]$SourceFile,
        
        [Parameter(Mandatory)]
        [string]$TargetFile,
        
        [string]$ExtractPath = ".",
        
        [int]$MaxRetries = 3,
        
        [switch]$ValidateOutput
    )
    
    $attempt = 0
    
    do {
        $attempt++
        Write-Host "Conversion attempt $attempt of $MaxRetries..."
        
        try {
            # Validate source file exists and is readable
            if (-not (Test-Path $SourceFile -PathType Leaf)) {
                throw "Source file '$SourceFile' not found"
            }
            
            # Test YAML syntax before processing
            $testResult = & yq eval 'keys' $SourceFile 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "Invalid YAML syntax: $testResult"
            }
            
            # Perform conversion
            $result = & yq eval $ExtractPath $SourceFile --output-format=json 2>&1
            
            if ($LASTEXITCODE -ne 0) {
                throw "yq conversion failed: $result"
            }
            
            # Validate JSON output if requested
            if ($ValidateOutput) {
                try {
                    $null = $result | ConvertFrom-Json
                    Write-Host "? JSON validation passed"
                } catch {
                    throw "Generated JSON is invalid: $_"
                }
            }
            
            # Write output with error handling
            try {
                $result | Out-File -FilePath $TargetFile -Encoding utf8 -NoNewline -ErrorAction Stop
                Write-Host "? Successfully generated $TargetFile"
                return $true
            } catch {
                throw "Failed to write output file: $_"
            }
            
        } catch {
            Write-Warning "? Attempt $attempt failed: $_"
            
            if ($attempt -ge $MaxRetries) {
                Write-Error "? All conversion attempts failed. Last error: $_"
                return $false
            }
            
            # Wait before retry with exponential backoff
            $waitTime = [Math]::Pow(2, $attempt - 1)
            Write-Host "Waiting $waitTime seconds before retry..."
            Start-Sleep -Seconds $waitTime
        }
        
    } while ($attempt -lt $MaxRetries)
    
    return $false
}
```

### Python Error Handling with Detailed Logging

```python
import yaml
import json
import logging
from typing import Any, Dict, Optional, Union
from pathlib import Path

class YamlToJsonProcessor:
    def __init__(self, log_level: str = "INFO"):
        # Configure detailed logging
        logging.basicConfig(
            level=getattr(logging, log_level.upper()),
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('yaml_conversion.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)
    
    def convert_with_validation(self, 
                              source_file: Path,
                              target_file: Path,
                              extract_path: Optional[str] = None,
                              validate_schema: bool = True) -> bool:
        """Convert YAML to JSON with comprehensive validation"""
        
        try:
            # Pre-conversion validation
            if not self._validate_source_file(source_file):
                return False
            
            # Load and parse YAML
            yaml_data = self._load_yaml_safe(source_file)
            if yaml_data is None:
                return False
            
            # Extract specific path if requested
            if extract_path:
                try:
                    yaml_data = self._extract_path(yaml_data, extract_path)
                    self.logger.info(f"Extracted path: {extract_path}")
                except KeyError as e:
                    self.logger.error(f"Path extraction failed: {e}")
                    return False
            
            # Validate data structure if requested
            if validate_schema:
                if not self._validate_data_structure(yaml_data):
                    return False
            
            # Convert to JSON with error handling
            try:
                json_content = json.dumps(yaml_data, indent=2, ensure_ascii=False, sort_keys=True)
                self.logger.info("JSON serialization successful")
            except (TypeError, ValueError) as e:
                self.logger.error(f"JSON serialization failed: {e}")
                return False
            
            # Write output with atomic operation
            return self._write_json_atomic(target_file, json_content)
            
        except Exception as e:
            self.logger.error(f"Unexpected error during conversion: {e}")
            return False
    
    def _validate_source_file(self, file_path: Path) -> bool:
        """Validate source file exists and is readable"""
        if not file_path.exists():
            self.logger.error(f"Source file does not exist: {file_path}")
            return False
        
        if not file_path.is_file():
            self.logger.error(f"Source path is not a file: {file_path}")
            return False
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                f.read(1)  # Test readability
            self.logger.info(f"Source file validation passed: {file_path}")
            return True
        except (IOError, OSError, UnicodeDecodeError) as e:
            self.logger.error(f"Source file validation failed: {e}")
            return False
    
    def _load_yaml_safe(self, file_path: Path) -> Optional[Dict[str, Any]]:
        """Safely load YAML with detailed error reporting"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check for common YAML issues
            if not content.strip():
                self.logger.error("YAML file is empty")
                return None
            
            # Attempt to parse YAML
            try:
                data = yaml.safe_load(content)
                self.logger.info(f"YAML parsed successfully, type: {type(data)}")
                return data
            except yaml.YAMLError as e:
                self.logger.error(f"YAML parsing error: {e}")
                
                # Try to provide helpful error context
                if hasattr(e, 'problem_mark'):
                    mark = e.problem_mark
                    self.logger.error(f"Error at line {mark.line + 1}, column {mark.column + 1}")
                
                return None
                
        except Exception as e:
            self.logger.error(f"Failed to read YAML file: {e}")
            return None
    
    def _write_json_atomic(self, target_file: Path, json_content: str) -> bool:
        """Write JSON file atomically to prevent corruption"""
        temp_file = target_file.with_suffix('.tmp')
        
        try:
            # Write to temporary file first
            with open(temp_file, 'w', encoding='utf-8') as f:
                f.write(json_content)
            
            # Verify temporary file was written correctly
            with open(temp_file, 'r', encoding='utf-8') as f:
                test_content = f.read()
                json.loads(test_content)  # Validate JSON
            
            # Atomically replace target file
            temp_file.replace(target_file)
            self.logger.info(f"? Successfully wrote {target_file}")
            return True
            
        except Exception as e:
            self.logger.error(f"Failed to write JSON file: {e}")
            
            # Cleanup temporary file
            if temp_file.exists():
                try:
                    temp_file.unlink()
                except:
                    pass
            
            return False
```

## Performance Optimization Techniques

### Streaming YAML Processing for Large Files

```python
import yaml
import json
from typing import Iterator, Any

def stream_yaml_to_json(yaml_file: Path, json_file: Path, chunk_size: int = 1000):
    """Process large YAML files in chunks to reduce memory usage"""
    
    def yaml_loader(file_path: Path) -> Iterator[Any]:
        """Generator to yield YAML documents one at a time"""
        with open(file_path, 'r', encoding='utf-8') as f:
            yield from yaml.safe_load_all(f)
    
    with open(json_file, 'w', encoding='utf-8') as outfile:
        outfile.write('[\n')
        
        first_doc = True
        doc_count = 0
        
        for document in yaml_loader(yaml_file):
            if not first_doc:
                outfile.write(',\n')
            else:
                first_doc = False
            
            json.dump(document, outfile, indent=2, ensure_ascii=False)
            doc_count += 1
            
            # Progress reporting
            if doc_count % chunk_size == 0:
                print(f"Processed {doc_count} documents...")
        
        outfile.write('\n]')
        
    print(f"? Processed {doc_count} documents total")
```

### Parallel Processing for Multiple Files

```python
import concurrent.futures
from multiprocessing import cpu_count
from pathlib import Path
from typing import List, Tuple

def batch_convert_yaml_to_json(
    file_pairs: List[Tuple[Path, Path]], 
    max_workers: Optional[int] = None
) -> List[bool]:
    """Convert multiple YAML files to JSON in parallel"""
    
    if max_workers is None:
        max_workers = min(cpu_count(), len(file_pairs))
    
    def convert_single_file(file_pair: Tuple[Path, Path]) -> bool:
        source, target = file_pair
        processor = YamlToJsonProcessor()
        return processor.convert_with_validation(source, target)
    
    results = []
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Submit all conversion tasks
        future_to_files = {
            executor.submit(convert_single_file, pair): pair 
            for pair in file_pairs
        }
        
        # Collect results as they complete
        for future in concurrent.futures.as_completed(future_to_files):
            file_pair = future_to_files[future]
            try:
                result = future.result()
                results.append(result)
                
                status = "?" if result else "?"
                print(f"{status} {file_pair[0]} -> {file_pair[1]}")
                
            except Exception as e:
                print(f"? Error processing {file_pair[0]}: {e}")
                results.append(False)
    
    success_count = sum(results)
    print(f"Conversion complete: {success_count}/{len(file_pairs)} successful")
    
    return results

# Usage example
file_pairs = [
    (Path("config1.yaml"), Path("config1.json")),
    (Path("config2.yaml"), Path("config2.json")),
    (Path("config3.yaml"), Path("config3.json")),
]

results = batch_convert_yaml_to_json(file_pairs)
```

## Custom Data Structure Handling

### Complex Nested Structure Processing

Based on our Quarto navigation structure, here's how to handle complex nested data:

```python
def process_quarto_navigation(yaml_data: Dict[str, Any]) -> Dict[str, Any]:
    """Process Quarto-specific navigation structure with enhanced metadata"""
    
    def process_navigation_item(item: Dict[str, Any], level: int = 0) -> Dict[str, Any]:
        """Recursively process navigation items with metadata enhancement"""
        
        processed = {}
        
        # Copy basic properties
        for key in ['text', 'href', 'section']:
            if key in item:
                processed[key] = item[key]
        
        # Add metadata
        processed['level'] = level
        processed['type'] = 'section' if 'section' in item else 'page'
        
        # Process children recursively
        if 'contents' in item and isinstance(item['contents'], list):
            processed['contents'] = [
                process_navigation_item(child, level + 1) 
                for child in item['contents']
            ]
            processed['children_count'] = len(processed['contents'])
        else:
            processed['children_count'] = 0
        
        # Generate unique ID
        if 'href' in processed:
            processed['id'] = processed['href'].replace('/', '_').replace('.', '_')
        elif 'section' in processed:
            processed['id'] = processed['section'].lower().replace(' ', '_')
        
        return processed
    
    # Extract website sidebar structure
    if 'website' in yaml_data and 'sidebar' in yaml_data['website']:
        sidebar = yaml_data['website']['sidebar']
        
        if 'contents' in sidebar:
            processed_contents = [
                process_navigation_item(item) 
                for item in sidebar['contents']
            ]
            
            return {
                'contents': processed_contents,
                'metadata': {
                    'generated_at': datetime.utcnow().isoformat(),
                    'total_items': sum(count_items(item) for item in processed_contents),
                    'max_depth': max(get_max_depth(item) for item in processed_contents)
                }
            }
    
    return {'contents': []}

def count_items(item: Dict[str, Any]) -> int:
    """Count total number of items in navigation tree"""
    count = 1
    if 'contents' in item:
        count += sum(count_items(child) for child in item['contents'])
    return count

def get_max_depth(item: Dict[str, Any], current_depth: int = 1) -> int:
    """Get maximum depth of navigation tree"""
    if 'contents' not in item or not item['contents']:
        return current_depth
    
    return max(
        get_max_depth(child, current_depth + 1) 
        for child in item['contents']
    )
```

## Cross-Platform Compatibility

### Universal Shell Script Implementation

```bash
#!/bin/bash
# convert-yaml-json.sh - Cross-platform YAML to JSON converter

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YQ_VERSION="v4.40.5"
YQ_BINARY=""

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Detect OS and architecture
detect_platform() {
    local os
    local arch
    
    case "$(uname -s)" in
        Darwin*)  os="darwin" ;;
        Linux*)   os="linux" ;;
        CYGWIN*|MINGW*|MSYS*) os="windows" ;;
        *)        log_error "Unsupported OS: $(uname -s)"; exit 1 ;;
    esac
    
    case "$(uname -m)" in
        x86_64|amd64) arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        *)           log_error "Unsupported architecture: $(uname -m)"; exit 1 ;;
    esac
    
    echo "${os}_${arch}"
}

# Download yq if not available
setup_yq() {
    # Check if yq is already available
    if command -v yq >/dev/null 2>&1; then
        YQ_BINARY="yq"
        log_info "Using system yq: $(which yq)"
        return
    fi
    
    # Download yq
    local platform
    platform=$(detect_platform)
    local binary_name="yq_${platform}"
    
    if [[ "$platform" == "windows"* ]]; then
        binary_name="${binary_name}.exe"
        YQ_BINARY="./yq.exe"
    else
        YQ_BINARY="./yq"
    fi
    
    local download_url="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${binary_name}"
    
    log_info "Downloading yq from: $download_url"
    
    if command -v curl >/dev/null 2>&1; then
        curl -L "$download_url" -o "${YQ_BINARY}"
    elif command -v wget >/dev/null 2>&1; then
        wget "$download_url" -O "${YQ_BINARY}"
    else
        log_error "Neither curl nor wget available for downloading yq"
        exit 1
    fi
    
    chmod +x "${YQ_BINARY}"
    log_info "yq downloaded successfully"
}

# Convert YAML to JSON with validation
convert_yaml_to_json() {
    local source_file="$1"
    local target_file="$2"
    local extract_path="${3:-.}"
    
    # Validate source file
    if [[ ! -f "$source_file" ]]; then
        log_error "Source file not found: $source_file"
        return 1
    fi
    
    # Test YAML syntax
    if ! "$YQ_BINARY" eval 'keys' "$source_file" >/dev/null 2>&1; then
        log_error "Invalid YAML syntax in: $source_file"
        return 1
    fi
    
    # Perform conversion
    log_info "Converting $source_file -> $target_file"
    log_info "Extract path: $extract_path"
    
    if "$YQ_BINARY" eval "$extract_path" "$source_file" --output-format=json > "$target_file"; then
        log_info "? Conversion successful"
        
        # Validate JSON output
        if command -v jq >/dev/null 2>&1; then
            if jq empty "$target_file" >/dev/null 2>&1; then
                log_info "? JSON validation passed"
            else
                log_warn "?? Generated JSON may be invalid"
            fi
        fi
        
        return 0
    else
        log_error "? Conversion failed"
        return 1
    fi
}

# Main function
main() {
    local source_file="${1:-}"
    local target_file="${2:-}"
    local extract_path="${3:-.}"
    
    if [[ -z "$source_file" || -z "$target_file" ]]; then
        echo "Usage: $0 <source.yaml> <target.json> [extract_path]"
        echo "Example: $0 _quarto.yml navigation.json '.website.sidebar.contents'"
        exit 1
    fi
    
    setup_yq
    convert_yaml_to_json "$source_file" "$target_file" "$extract_path"
}

# Run main function with all arguments
main "$@"
```

This appendix provides comprehensive technical details for implementing robust YAML to JSON conversion systems based on our production experience and extensive testing across different platforms and scenarios.