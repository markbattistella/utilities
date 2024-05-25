' Word2DV Macro
' Copyright (c) 2016
' Created by Mark Battistella
' Do not alter anything or else the world will break


Attribute VB_Name = "NewMacros"
Sub Word2DV()

    ' Show the messages about this macro
    alert = "This will convert your current document into a DV Widescreen (1024x576) format"
    alert = alert & vbCrLf & " "
    alert = alert & vbCrLf & "Ensure the document doesn't spill to two pages"
    alert = alert & vbCrLf & " "
    alert = alert & vbCrLf & "The output will already be within the 90% margin"
    alert = alert & vbCrLf & " "
    alert = alert & vbCrLf & "The output document will save as a PDF"
    alert = alert & vbCrLf & " "
    alert = alert & vbCrLf & "If the Word document is not saved, the PDF will save in My Documents"
    alert = alert & vbCrLf & " "
    alert = alert & vbCrLf & "Are you sure you want to continue?"

    alertMsg = alert

    ' Ask the question of continuation
    questionPress = MsgBox(alertMsg, vbQuestion + vbYesNo, "Convert document to DV widescreen   ;)")

    If questionPress = vbYes Then

        fontPrompt = "What font size should the text be?"
        fontTitle = "Set the font size"
        fontDefault = "20"
        FontSize = InputBox(fontPrompt, fontTitle, fontDefault)

        WordBasic.PageSetupPaper Tab:=0, PaperSize:=0, TopMargin:="0.76", _
        BottomMargin:="0.76", LeftMargin:="1.35", RightMargin:="1.35", Gutter:= _
        "0", PageWidth:="27.09", PageHeight:="15.24", Orientation:=1, FirstPage:= _
        0, OtherPages:=0, VertAlign:=0, ApplyPropsTo:=4, FacingPages:=0, _
        HeaderDistance:="1.25", FooterDistance:="1.25", SectionStart:=2, _
        OddAndEvenPages:=0, DifferentFirstPage:=0, Endnotes:=0, LineNum:=0, _
        CountBy:=0, TwoOnOne:=0, GutterPosition:=0, LayoutMode:=0, DocFontName:= _
        "", FirstPageOnLeft:=0, SectionType:=1, FolioPrint:=0, ReverseFolio:=0, _
        FolioPages:=1
            Selection.WholeStory
            Selection.Font.Name = "Arial"
            Selection.Font.Size = FontSize
            Selection.ParagraphFormat.LineSpacing = LinesToPoints(1)
                With Selection.ParagraphFormat
                    .LeftIndent = CentimetersToPoints(0)
                    .RightIndent = CentimetersToPoints(0)
                    .SpaceBefore = 0
                    .SpaceBeforeAuto = False
                    .SpaceAfter = 10
                    .SpaceAfterAuto = False
                    .LineSpacingRule = wdLineSpaceSingle
                    .Alignment = wdAlignParagraphLeft
                    .WidowControl = True
                    .KeepWithNext = False
                    .KeepTogether = False
                    .PageBreakBefore = False
                    .NoLineNumber = False
                    .Hyphenation = True
                    .FirstLineIndent = CentimetersToPoints(0)
                    .OutlineLevel = wdOutlineLevelBodyText
                    .CharacterUnitLeftIndent = 0
                    .CharacterUnitRightIndent = 0
                    .CharacterUnitFirstLineIndent = 0
                    .LineUnitBefore = 0
                    .LineUnitAfter = 0
                    .MirrorIndents = False
                    .TextboxTightWrap = wdTightNone
                End With

    ActiveDocument.ExportAsFixedFormat OutputFileName:= _
        Replace(ActiveDocument.FullName, ".docx", ".pdf"), _
        ExportFormat:=wdExportFormatPDF, OpenAfterExport:=False, OptimizeFor:= _
        wdExportOptimizeForPrint, Range:=wdExportAllDocument, Item:= _
        wdExportDocumentContent, IncludeDocProps:=False, KeepIRM:=True, _
        CreateBookmarks:=wdExportCreateNoBookmarks, DocStructureTags:=True, _
        BitmapMissingFonts:=True, UseISO19005_1:=False

    Else

        noPress = MsgBox("You did not process the document   :(", vbCritical + vbOKOnly, "Word to DV Widescreen aborted :(")

    End If
End Sub
