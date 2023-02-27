@{
    RootModule        = 'DevContainers.psm1';
    ModuleVersion     = '1.0.0.0';
    GUID              = 'cbcdec4a-5259-4c73-a394-f71c87af75ed';
    Description       = 'Manages development containers';
    PowerShellVersion = '7.0';

    FunctionsToExport = @(
        'New-DevContainer',
        'Convert-DevContainer',
        'Enter-DevContainer'
        'Remove-DevContainer'
    );
}
