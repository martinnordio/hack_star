# PowerShell — baseline

> Rules for the PowerShell scripts of the project and of this kit (`.specs/kit/tools/`).
> `.specs/guidelines/powershell.md` wins over this file. Reference:
> [PowerShell docs](https://learn.microsoft.com/powershell/scripting/).

## Compatibility

- Scripts run in **Windows PowerShell 5.1 and PowerShell 7**: no `??`, `?.`, ternary `? :` or
  `&&` / `||` between commands; `#Requires -Version 5.1`.
- Files read by Windows PowerShell 5.1 contain **only ASCII** characters (or are saved as
  UTF-8 with a byte-order mark): 5.1 misreads other characters.

## Structure

- `[CmdletBinding()]` and a `param()` block with typed, named parameters; mandatory ones
  marked `Mandatory`.
- Approved verbs in function names (`Get-`, `Set-`, `New-`, `Update-`, …), `PascalCase`
  parameters.
- Changes to anything outside the script get a `-DryRun` switch (or `SupportsShouldProcess`
  with `-WhatIf`).

## Errors

- `$ErrorActionPreference = 'Stop'` at the top; `try` / `catch` where the user needs a clear
  message.
- Check the exit code of external programs (`gh`, `git`, `uv`, `npm`) with `$LASTEXITCODE` and
  stop on failure.
- Never print secrets; read tokens from environment variables, never from parameters with
  defaults.

## Style

- Full cmdlet names, no aliases (`Get-ChildItem`, not `ls`); `Join-Path` for paths; quote
  paths with spaces.
- Output objects, not formatted text, from functions; `Write-Host` only for messages to the
  user.

## Checks before a Step is done

- The script parses (`[System.Management.Automation.Language.Parser]::ParseFile`), contains
  only ASCII, and the dry run shows the expected result.
