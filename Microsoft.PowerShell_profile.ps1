oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\half-life.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

# Alias

Set-Alias -Name vim -Value nvim
Set-Alias g git

# Cấu hình FZF để sử dụng bat làm preview
$ENV:FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# Tạo function ff để mở fzf và edit file bằng neovim
function ff {
    $file = fzf
    if ($file) {
        nvim-qt $file
    }
}

# Cấu hình để sử dụng bat thay vì cat mặc định
Set-Alias -Name cat -Value bat
