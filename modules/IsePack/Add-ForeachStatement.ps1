function Add-ForeachStatement
{
    <#
    .Synopsis
        Adds a Foreach Statement to the ISE
    .Description
        Adds a Foreach Statement to the ISE
    .Example
        Add-ForeachStatement    
    #>
    param()
    $l = $psise.CurrentFile.Editor.CaretLine
    $c = $psise.CurrentFile.Editor.CaretColumn
    $x = ''
    if ($c -ne 0)
    {
        $x = ' ' * ($c - 1)
    }
    $psise.CurrentFile.Editor.InsertText("foreach(`$ in `$)`n" + $x + "{`n" + $x + "}")
    $psise.CurrentFile.Editor.SetCaretPosition($l, $c + 9)
}
