# mdbook Logo Pipeline

A robust shell script pipeline for adding company logos to [mdbook](https://rust-lang.github.io/mdBook/) projects with template-based customization and batch processing capabilities.

## Features

- **Template-based approach**: Separate code from data using external CSS and configuration templates
- **Batch processing**: Set up logos across multiple mdbook projects efficiently
- **Robust error handling**: Comprehensive validation, backup creation, and error recovery
- **Responsive design**: Mobile-friendly logo placement with dark theme support
- **Accessibility**: High contrast mode, reduced motion preferences, and RTL language support
- **Safe operations**: Automatic backups of existing files before modification
- **Flexible configuration**: Support for different logos per project or shared logos

## Quick Start

1. **Download the pipeline files**
2. **Make scripts executable:**
   ```bash
   chmod +x mdbook-logo-setup.sh batch-setup-example.sh
   ```
3. **Set up a single project:**
   ```bash
   cd /path/to/your/mdbook/project
   LOGO_PATH=/path/to/logo.png \
   CSS_TEMPLATE_PATH=./templates/mdbook-logo.css \
   ./mdbook-logo-setup.sh
   ```

## Directory Structure

```
mdbook-logo-pipeline/
├── README.md                      # This file
├── mdbook-logo-setup.sh          # Main setup script
├── batch-setup-example.sh        # Multi-project batch processor
├── templates/
│   ├── mdbook-logo.css           # CSS template with logo styling
│   └── book-config-addition.toml # mdbook configuration template
└── examples/
    └── logos/                    # Example logo files
```

## Installation

1. **Clone or download this repository:**
   ```bash
   git clone <repository-url>
   cd mdbook-logo-pipeline
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

3. **Verify prerequisites:**
   - [mdbook](https://rust-lang.github.io/mdBook/guide/installation.html) installed
   - Bash shell (Linux/macOS/WSL)
   - Logo files in supported formats (PNG, JPG, JPEG, GIF, SVG, WebP)

## Usage

### Single Project Setup

```bash
cd /path/to/your/mdbook/project

# Basic usage with CSS template
LOGO_PATH=/path/to/logo.png \
CSS_TEMPLATE_PATH=./templates/mdbook-logo.css \
./mdbook-logo-setup.sh

# With book configuration template
LOGO_PATH=/path/to/logo.png \
CSS_TEMPLATE_PATH=./templates/mdbook-logo.css \
BOOK_CONFIG_TEMPLATE_PATH=./templates/book-config-addition.toml \
./mdbook-logo-setup.sh
```

### Batch Processing Multiple Projects

1. **Edit `batch-setup-example.sh`** to configure your projects:
   ```bash
   # Individual logos per project
   PROJECTS=(
       "/path/to/project1:/path/to/logos/company1-logo.png"
       "/path/to/project2:/path/to/logos/company2-logo.svg"
       "/path/to/project3:/path/to/logos/company3-logo.png"
   )
   ```

   Or use a shared logo:
   ```bash
   # Shared logo for all projects
   SHARED_LOGO="/path/to/shared/company-logo.png"
   PROJECTS=(
       "/path/to/project1"
       "/path/to/project2"
       "/path/to/project3"
   )
   ```

2. **Run the batch processor:**
   ```bash
   ./batch-setup-example.sh
   ```

## Environment Variables

### Required
- `LOGO_PATH`: Full path to the logo file
- `CSS_TEMPLATE_PATH`: Full path to the CSS template file

### Optional
- `BOOK_CONFIG_TEMPLATE_PATH`: Full path to book.toml template (falls back to inline config)

## Template System

### CSS Template (`templates/mdbook-logo.css`)

The CSS template uses placeholders that are automatically replaced:
- `LOGO_FILENAME`: Replaced with the actual logo filename

**Key features:**
- Responsive design (mobile, tablet, desktop)
- Dark theme compatibility (coal, navy, ayu themes)
- Accessibility support (high contrast, reduced motion)
- RTL language support
- Print CSS (hides logo when printing)
- Optional animations and hover effects (commented out)

### Book Configuration Template (`templates/book-config-addition.toml`)

Contains mdbook configuration options including:
- Custom CSS inclusion
- Optional theme settings
- Search configuration examples
- Git repository integration
- Additional customization options

## What the Script Does

1. **Validates** environment variables and file paths
2. **Checks** mdbook project structure
3. **Creates** `theme/` directory if needed
4. **Copies** logo file to project's theme directory
5. **Processes** CSS template, substituting placeholders
6. **Updates** `book.toml` with configuration
7. **Creates** timestamped backups of existing files
8. **Verifies** setup completion

## Customization

### Creating Custom CSS Templates

Copy and modify `templates/mdbook-logo.css`:

```css
/* Your custom CSS */
.menu-title::before {
    content: "";
    background: url('LOGO_FILENAME') no-repeat center;
    /* Your custom styling */
}
```

The `LOGO_FILENAME` placeholder will be automatically replaced.

### Logo Positioning Options

The default template places logos:
- Before the menu title (always visible)
- Optionally before chapter titles (commented out)

Uncomment sections in the CSS template to enable additional logo placements.

### Theme Compatibility

The CSS template includes optimizations for all mdbook themes:
- **Light theme**: Default brightness
- **Coal/Navy themes**: Slight brightness reduction
- **Ayu theme**: Enhanced contrast for visibility

## Advanced Usage

### Multiple CSS Templates

Create different templates for different project types:

```bash
# Corporate template
CSS_TEMPLATE_PATH=./templates/corporate-logo.css

# Open source template  
CSS_TEMPLATE_PATH=./templates/oss-logo.css

# Minimal template
CSS_TEMPLATE_PATH=./templates/minimal-logo.css
```

### Custom Project Configurations

Use different book configuration templates:

```bash
# API documentation projects
BOOK_CONFIG_TEMPLATE_PATH=./templates/api-docs-config.toml

# User guides
BOOK_CONFIG_TEMPLATE_PATH=./templates/user-guide-config.toml
```

## Error Handling

The scripts include comprehensive error handling:

- **Validation**: Checks all file paths and permissions before processing
- **Backups**: Creates timestamped backups of existing files
- **Rollback**: Manual rollback using backup files if needed
- **Cleanup**: Proper cleanup on script interruption
- **Reporting**: Detailed success/failure reporting for batch operations

## Troubleshooting

### Common Issues

1. **"Logo file does not exist"**
   - Verify the `LOGO_PATH` points to an existing file
   - Check file permissions (must be readable)

2. **"Not in a valid mdbook project directory"**
   - Ensure you're in a directory containing `book.toml`
   - Run `mdbook init` to create a new project if needed

3. **"CSS template file does not exist"**
   - Check the `CSS_TEMPLATE_PATH` is correct
   - Ensure template files are in the expected location

4. **Logo not appearing**
   - Run `mdbook build` and check the output
   - Verify logo file was copied to `theme/` directory
   - Check browser developer tools for CSS issues

### Getting Help

1. **Run with help flag:**
   ```bash
   ./mdbook-logo-setup.sh --help
   ./batch-setup-example.sh --help
   ```

2. **Check script output:** Scripts provide detailed logging with color-coded messages

3. **Verify file structure:** Ensure all required files are present and accessible

## Examples

### Corporate Documentation Setup

```bash
# Set up 20 different project documentation with individual company logos
for i in {1..20}; do
    cd "/path/to/docs/company${i}"
    LOGO_PATH="/assets/logos/company${i}-logo.png" \
    CSS_TEMPLATE_PATH="/shared/templates/corporate-mdbook.css" \
    BOOK_CONFIG_TEMPLATE_PATH="/shared/templates/corporate-config.toml" \
    /shared/scripts/mdbook-logo-setup.sh
done
```

### Open Source Project Setup

```bash
# Single logo across multiple project repositories
SHARED_LOGO="/assets/oss-project-logo.svg"
for project in /repos/*/docs; do
    cd "$project"
    LOGO_PATH="$SHARED_LOGO" \
    CSS_TEMPLATE_PATH="/templates/oss-mdbook.css" \
    /scripts/mdbook-logo-setup.sh
done
```

## Benefits

- **Maintainable**: Update CSS template once, apply everywhere
- **Flexible*