@{
    RootModule        = 'Misc.psm1';
    ModuleVersion     = '1.0.0.0';
    GUID              = '7c5798c4-fc4e-4427-acfa-1c6116cb7d2d';
    Description       = 'Random cli things';
    PowerShellVersion = '7.0';

    FunctionsToExport = @(
        'Get-ChildContent',
        'Initialize-PwshContainer'
    );

    AliasesToExport = @(
        'lss'
    );
}
