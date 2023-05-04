VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ChartApiGoogle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

Const BLANK = " "

Rem tipo de gráfico que se puede mostrar
Const COLUMNCHART_C = "ColumnChart"
Const BARCHART_C = "BarChart"
Const LINECHART_C = "LineChart"
Const AREACHART_C = "AreaChart"
Const STEPPEDAREACHART_C = "SteppedAreaChart"
Const COMBOCHART_C = "ComboChart"
Const PIECHART_C = "PieChart"

Public title As String
Public headString As String
Public headNumber As String
Public table As String
Public widthChart As Integer
Public eightChart As Integer
Public typeChart As String

Public Sub openWebChart()
    'leer html
    Dim indexHTML As String
    Dim content As String
    Dim funcJS As String
    
    Dim fso As New Scripting.FileSystemObject
    indexHTML = CurrentProject.Path & "\index.html"

    If createFileJavascript() Then
        Shell "cmd.exe /k start chrome.exe " & """" & indexHTML & """", vbHide
    End If
    
End Sub
Public Function createFileJavascript() As Boolean

    Dim pathJavascript As String
    Dim funcJS As String
    Dim fso As New Scripting.FileSystemObject
    
    pathJavascript = CurrentProject.Path & "\javascripts\script.js"
    funcJS = writeJavascript()
    
    If fso.FileExists(pathJavascript) Then fso.DeleteFile (pathJavascript)
    
    If writeFile(funcJS, pathJavascript) Then
        createFileJavascript = True
    End If
    
End Function

Private Function writeJavascript() As String
    
    Dim loadPackage As String
    Dim callDrawchart As String
    Dim addRows As Collection
    Dim funcDrawChart As String
    Dim options As String
    Dim var_chart As String
    Dim chart As String
    
    loadPackage = "google.charts.load('current', {'packages':['corechart']});"
    callDrawchart = "google.charts.setOnLoadCallback(drawChart);"
    
    Set addRows = readRecordset(headString, headNumber, table)
    funcDrawChart = drawChartForJavascript(addRows, headString, headNumber)
    
    options = formatString("var options = {'title':'{0}','width':{1},'eight':{2}};", title, widthChart, eightChart)
    var_chart = formatString("var chart = new google.visualization.{0}(document.getElementById('chart_div'));", typeChart)
    chart = "chart.draw(data, options);" & vbCrLf & "}"
    
    
    writeJavascript = formatString(loadPackage + "{0}" + callDrawchart + "{0}" + funcDrawChart + "{0}{1}{1}" + options + "{0}{1}{1}" + var_chart + "{0}{1}{1}" + chart, _
                    vbCrLf, BLANK)
                    
End Function


Private Function readRecordset(ByVal field_1 As String, ByVal field_2 As String, ByVal table As String) As Collection
    
    Dim rs As Recordset
    Dim sql As String
    Dim addRows As New Collection

    sql = formatString("select {0},{1} from {2}", field_1, field_2, table)
        
    Set rs = CurrentDb.OpenRecordset(sql)
    
    With rs
        If .EOF And .BOF Then
            Debug.Print "No hay registros"
        Else
            .MoveFirst
            Do While Not (.EOF)
                 addRows.Add formatString( _
                                            "['{0}',{1}]", _
                                            .Fields(field_1).Value, _
                                            .Fields(field_2).Value)
                .MoveNext
            Loop
        End If
    End With
    
    Set readRecordset = addRows
    Debug.Print vbCrLf; "Proceso terminado"
    
End Function
Private Function formatString(ByVal text As String, ParamArray values()) As String
    
    Dim i As Integer
    
    For i = LBound(values) To UBound(values)
        text = Replace(text, "{" & i & "}", values(i))
    Next i
    
    formatString = text
    
End Function
Private Function drawChartForJavascript(ByRef addRows As Collection, ByVal head1 As String, ByVal head2 As String) As String

    Dim funcJavascript As String
    Dim arrToJs As String
    
    arrToJs = converter_coll_to_array_javascript(addRows)
    funcJavascript = formatString("function drawChart() {{1}{0}{0}var data = new google.visualization.DataTable();{1}{0}{0}data.addColumn('string', '{2}');{1}{0}{0}data.addColumn('number', '{3}');{1}{0}{0}data.addRows([{1}{0}{0}{0}{0}{4}{1}{0}{0}]);", BLANK, vbCrLf, head1, head2, arrToJs)
    
    drawChartForJavascript = funcJavascript
    
End Function
Private Function converter_coll_to_array_javascript(ByRef arrCollection As Collection) As String
    
    Dim arrToJs As String
    Dim i As Integer
    
    For i = 1 To arrCollection.Count
        If i = 1 Then
            arrToJs = arrCollection.Item(i)
        Else
            arrToJs = arrToJs & "," & vbCrLf & BLANK & BLANK & BLANK & BLANK & arrCollection.Item(i)
        End If
    Next i
    
    converter_coll_to_array_javascript = arrToJs
    
End Function
Private Function readFile(ByVal pathFile As String) As String
    
    Dim fso As New Scripting.FileSystemObject
    Dim t As TextStream
    Dim content As String
    
    If fso.FileExists(pathFile) Then
        Set t = fso.OpenTextFile(pathFile, ForReading)
        content = t.ReadAll
        t.Close
        readFile = content
    Else
        Err.Raise 1 + vbObjectError, _
        , _
        "No se encontro el archivo en esta ruta " + vbCrLf + vbCrLf + pathFile
        
    End If
    
    Set fso = Nothing
    Set t = Nothing
    
End Function

Private Function writeFile(ByVal content As String, Optional pathTarget) As Boolean
    
    Dim fso As New Scripting.FileSystemObject
    Dim t As TextStream
    Dim userProfile As String
    
    On Error GoTo Cath
    
    userProfile = Environ$("UserProfile")
    
    If IsMissing(pathTarget) Then: pathTarget = userProfile & "\content.txt"
    
    Set t = fso.OpenTextFile(pathTarget, ForWriting, True, -1)
    t.Write content
    t.Close
    
    writeFile = True
    Exit Function
    
Cath:

    writeFile = False
    
End Function

Rem funciones que devuelven una constante para el cambiar el tipo de gráfico
Public Property Get ColumnChart() As String
    ColumnChart = COLUMNCHART_C
End Property
Public Property Get BarChart() As String
    BarChart = BARCHART_C
End Property
Public Property Get LineChart() As String
    LineChart = LINECHART_C
End Property
Public Property Get AreaChart() As String
    AreaChart = AREACHART_C
End Property
Public Property Get SteppedAreaChart() As String
    SteppedAreaChart = STEPPEDAREACHART_C
End Property
Public Property Get ComboChart() As String
    ComboChart = COMBOCHART_C
End Property
Public Property Get PieChart() As String
    PieChart = PIECHART_C
End Property

Private Sub Class_Initialize()

    With Me
        .title = "Gráfico generado para Access"
        .widthChart = 800
        .eightChart = 600
        .typeChart = PIECHART_C
    End With
    
End Sub
