# Contributing to Phantom Terminal

Thank you for your interest in contributing! 🎉

## 🐛 Bug Reports

1. Check [existing issues](https://github.com/Unknown-2829/Phanton-terminal/issues) first
2. Create a new issue with:
   - Platform + shell version (Windows/PowerShell, Linux/bash, macOS/zsh, or Termux)
   - Terminal (Windows Terminal, ConHost, Alacritty, Kitty, tmux, etc.)
   - Steps to reproduce
   - Expected vs actual behavior

## 💡 Feature Requests

Open an issue with `[Feature]` in the title and describe:
- What you want
- Why it's useful
- How it might work

## 🔧 Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes in the relevant startup script(s): `PhantomStartup.ps1` and/or `PhantomStartup.sh`
4. Update related docs when applicable (`README.md`, `CHANGELOG.md`, version strings)
5. Test thoroughly on the platform(s) you touched
6. Commit: `git commit -m "Add: my feature"`
7. Push: `git push origin feature/my-feature`
8. Open a Pull Request

## 📝 Code Style

- Use 4-space indentation
- Comment complex logic
- Follow existing naming conventions (`Show-*`, `Get-*`, etc.)
- Keep functions focused and small

## 🧪 Testing

Before submitting:
```powershell
# Test fresh install
. .\PhantomStartup.ps1

# Test commands
phantom-reload
phantom-config
phantom-matrix
```

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.
