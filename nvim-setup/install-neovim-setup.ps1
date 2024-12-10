# install-neovim-setup.ps1

# Hàm kiểm tra và tạo thư mục
function EnsureDirectory {
    param($Path)
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

# Hàm ghi log
function Write-Log {
    param($Message, $Type = "Info")
    $color = switch ($Type) {
        "Info" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
    }
    Write-Host "[$Type] $Message" -ForegroundColor $color
}

# 1. Cài đặt Scoop nếu chưa có
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Log "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

# 2. Thêm các bucket cần thiết
Write-Log "Adding Scoop buckets..."
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts

# 3. Cài đặt các ứng dụng qua Scoop
$scoopApps = @(
    "git",
    "neovim",
    "nodejs",
    "python",
    "ripgrep",
    "fd",
    "lazygit",
    "JetBrainsMono-NF-Mono",
	"fzf",
	"bat",
	"less",
    "make",
    "llvm"    # cho clangd và C/C++
)

foreach ($app in $scoopApps) {
    Write-Log "Installing $app..." "Info"
    scoop install $app
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Failed to install $app" "Error"
    }
}

# 4. Cài đặt các package npm cho web development
$npmPackages = @(
    "neovim",
    "live-server",
    "typescript",
    "typescript-language-server",
    "prettier",
    "eslint",
    "vscode-langservers-extracted",  # Cho HTML/CSS/JSON
    "emmet-ls",                      # Cho HTML/CSS
    "@tailwindcss/language-server"
)

foreach ($package in $npmPackages) {
    Write-Log "Installing npm package: $package..."
    npm install -g $package
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Failed to install npm package: $package" "Error"
    }
}
# Thêm Python Scripts vào PATH
$pythonScriptsPath = "$env:APPDATA\Python\Python313\Scripts"
if (!(($env:Path).Split(';') -contains $pythonScriptsPath)) {
    $env:Path += ";$pythonScriptsPath"
    [Environment]::SetEnvironmentVariable(
        "Path",
        $env:Path,
        [System.EnvironmentVariableTarget]::User
    )
    Write-Log "Added Python Scripts to PATH" "Info"
}

# 5. Cài đặt các package Python
$pipPackages = @(
    "pynvim",
    "black",
    "pylint",
    "pyright",
    "flake8",
    "debugpy"
)

foreach ($package in $pipPackages) {
    Write-Log "Installing pip package: $package..."
    pip install --user $package
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Failed to install pip package: $package" "Error"
    }
}

# 6. Cài đặt Packer.nvim
$packerPath = "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
if (!(Test-Path $packerPath)) {
    Write-Log "Installing Packer.nvim..."
    git clone https://github.com/wbthomason/packer.nvim $packerPath
}

# 7. Tạo cấu trúc thư mục Neovim
$nvimPath = "$env:LOCALAPPDATA\nvim"
$pluginsPath = "$nvimPath\lua\plugins"

# Backup cấu hình cũ nếu có
if (Test-Path $nvimPath) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = "$nvimPath-backup-$timestamp"
    Write-Log "Creating backup of existing configuration..." "Warning"
    Copy-Item -Path $nvimPath -Destination $backupPath -Recurse -Force
}

# Tạo cấu trúc thư mục mới
EnsureDirectory $nvimPath
EnsureDirectory $pluginsPath

# 8. Copy các file cấu hình
$configFiles = @{
    "init.lua" = "$nvimPath\init.lua"
    "ginit.vim" = "$nvimPath\ginit.vim"
    "lua\plugins\init.lua" = "$nvimPath\lua\plugins\init.lua"
    "lua\plugins\settings.lua" = "$nvimPath\lua\plugins\settings.lua"
    "lua\plugins\git.lua" = "$nvimPath\lua\plugins\git.lua"
}

foreach ($file in $configFiles.Keys) {
    $sourcePath = Join-Path $PSScriptRoot $file
    $destPath = $configFiles[$file]
    
    if (Test-Path $sourcePath) {
        Write-Log "Copying $file to $destPath..."
        Copy-Item -Path $sourcePath -Destination $destPath -Force
    } else {
        Write-Log "Source file not found: $sourcePath" "Error"
    }
}

# 9. Cấu hình Git
git config --global core.editor "nvim"

# 10. Hiển thị thông tin kết thúc
Write-Log "`nInstallation completed!" "Info"
Write-Log "Next steps:" "Info"
Write-Log "1. Open Neovim and run :PackerSync" "Info"
Write-Log "2. Run :checkhealth to verify installation" "Info"
Write-Log "3. Run :Mason to install LSP servers" "Info"
Write-Log "4. Run :TSInstall all for Treesitter parsers" "Info"

# Kiểm tra lỗi
$errorCount = $Error.Count
if ($errorCount -gt 0) {
    Write-Log "`nWarning: $errorCount errors occurred during installation." "Warning"
    Write-Log "Please check the output above for details." "Warning"
}

# Hướng dẫn sử dụng
Write-Log "`nTo start using Neovim:" "Info"
Write-Log "1. Open Neovim by typing 'nvim' in terminal" "Info"
Write-Log "2. Wait for all plugins to be installed" "Info"
Write-Log "3. Restart Neovim after installation completes" "Info"
