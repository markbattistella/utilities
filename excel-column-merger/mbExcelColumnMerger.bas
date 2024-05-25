' ExcelColumnMerger Macro
' Copyright (c) 2020
' Created by Matthew Baldwin
' Modified by Mark Battistella
' Do not alter anything or else the world will break


Sub copyMatterIds()

    Dim ws As Worksheet
    Dim wsDest As Worksheet

	' create a output worksheet
    If Not WorksheetExists("MatterIds") Then
        Sheets.Add.Name = "MatterIds"
    End If

	' set the destination
    Set wsDest = Sheets("MatterIds")

	' loop all sheets in Workbook
    For Each ws In ActiveWorkbook.Sheets

		' if the worksheet is not the destination (otherwise endless loop)
		' if the worksheet is not the SQL script sheet
        If ws.Name <> wsDest.Name And ws.Name <> "SQL" Then

			' from A3 to last cell entry
			' A1:A2 are headings in my case
            ws.Range("A3", ws.Range("A1").End(xlDown)).Copy

			' paste into destination sheet, offset 1 cell down
            wsDest.Cells(Rows.Count, "A").End(xlUp).Offset(1).PasteSpecial xlPasteValues


			' my application also needs this column
			ws.Range("E2", ws.Range("E2").End(xlDown)).Copy

			' paste them into column B for destination
			wsDest.Cells(Rows.Count, "B").End(xlUp).Offset(0).PasteSpecial xlPasteValues
        End If
    Next ws

End Sub


' see if the sheet name exists
Function WorksheetExists(sName As String) As Boolean
    WorksheetExists = Evaluate("ISREF('" & sName & "'!A1)")

	' show all sheets only on this step
	showAllSheets()
End Function


' show all worksheets in the tabs
Function showAllSheets()
	For Each ws In Sheets: ws.Visible = True: Next
End Sub
