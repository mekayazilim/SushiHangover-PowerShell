#requires -version 2.0
function Add-OverlayFilter {    
    <#
    .Synopsis
    Creates a filter for overlaying images.

    .Description
    The Add-OverlayFilter function adds a Stamp filter of an image to a filter collection.
    The stamp filter lets you layer the specified image over another images.
    Add-OverlayFilter creates a new filter collection if none exists. 

    An image filter is Windows Image Acquisition (WIA) concept.
    Each filter represents a change to an image. 
    Add-OverlayFilter does not overlay images; it only creates a filter. 
    To overlay the image use the Set-ImageFilter function, which applies the filters.

    The Image parameter of Add-OverlayFilter is required. You cannot create a stamp (overlay) filter that is not specific to an image. 

    .Parameter Image
    Mandatory. Creates a stamp filter of the specified image.
    This parameter is required. Enter an image object, such as one returned by the Get-Image function.
    The image that is used in the filter is placed over other images when you apply the filter.

    .Parameter Filter
    Enter a filter collection (a Wia.ImageProcess COM object).
    You can also pipe a filter collection to Add-OverlayFilter.
    Each filter in the collection represents one change to an image.
    This parameter is optional. If you do not submit a filter collection, Add-OverlayFilter creates one for you.

    .Parameter Left
    The horizontal location within the image where the overlay is added. 
    The default value is zero (0). Enter a value in pixels from the left edge of the image.

    .Parameter Top
    The vertical location within the image where the overlay is added. 
    The default value is zero (0). Enter a value in pixels from the top edge of the image.

    .Parameter Passthru
    Returns an object that represents the stamp filter. 
    By default, this function does not generate output.

    .Notes
    Add-OverlayFilter uses the Wia.ImageProcess object.

    .Example
    Add-OverlayFilter –image (get-image .\Colors.jpg) –left 10 –top 10 –passthru

    .Example
    $i = get-image .\Colors.jpg
    $ol = Add-OverlayFilter –image $i –top 42 –passthru

    .Example
    C:\PS> $i = get-image .\Colors.jpg
    C:\PS> $of = Add-OverlayFilter –image $i –top 20 –left 20 –passthru
    C:\PS> ($of.filters | select properties).properties |  format-table –property Name, Value –auto

    Name       Value          
    ----       -----          
    ImageFile  System.__ComObject
    Left       20
    Top        20
    FrameIndex 0     


    .Example
    $layer = Get-Image .\Prism.jpg
    $photo = Get-Image .\Photo01.jpg            
    $NewImage = $photo | Set-ImageFilter -filter (Add-OverLayFilter -Image $layer -Left 10 -Top 10 -passThru) -passThru                    
    $NewImage.SaveFile(".\Photo01_Edited.jpg")

    .Link
    Get-Image

    .Link
    Set-ImageFilter

    .Link
    Image Manipulation in PowerShell:
    http://blogs.msdn.com/powershell/archive/2009/03/31/image-manipulation-in-powershell.aspx

    .Link
    "ImageProcess object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms630507(VS.85).aspx

    .Link
    "Filter Object" in MSDN 
    http://msdn.microsoft.com/en-us/library/ms630501(VS.85).aspx

    .Link
    "How to Use Filters" in MSDN
    http://msdn.microsoft.com/en-us/library/ms630819(VS.85).aspx
    #>

    param(
    [Parameter(ValueFromPipeline=$true)]
    [__ComObject]
    $filter,
    
    [__ComObject]
    $image,
        
    [Double]$left,
    [Double]$top,
    
    [switch]$passThru                      
    )
    
    process {
        if (-not $filter) {
            $filter = New-Object -ComObject Wia.ImageProcess
        } 
        $index = $filter.Filters.Count + 1
        if (-not $filter.Apply) { return }
        $stamp = $filter.FilterInfos.Item("Stamp").FilterId                    
        $filter.Filters.Add($stamp)
        $filter.Filters.Item($index).Properties.Item("ImageFile") = $image.PSObject.BaseObject
        $filter.Filters.Item($index).Properties.Item("Left") = $left
        $filter.Filters.Item($index).Properties.Item("Top") = $top
        if ($passthru) { return $filter }         
    }
}
 
