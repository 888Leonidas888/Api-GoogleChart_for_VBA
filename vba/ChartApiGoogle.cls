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
Const OPTION_DEFAULT_CHART = "{'title':'Gráfico generado para MsAccess','width':800,'height':600}"

Rem tipo de gráfico que se puede mostrar
Const COLUMNCHART_C = "ColumnChart"
Const BARCHART_C = "BarChart"
Const LINECHART_C = "LineChart"
Const AREACHART_C = "AreaChart"
Const STEPPEDAREACHART_C = "SteppedAreaChart"
Const COMBOCHART_C = "ComboChart"
Const PIECHART_C = "PieChart"

Private headColumn() As Variant

Public table As String
Public typeChart As String
Public includeHead As Boolean

Private optionVisualization As String
Public customChart As String

Public Sub openWebChart()
    Rem muestra en el navegador chrome el grafico con los datos extraídos de Access
    
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
    
    Rem elimina el fichero script.js y lo vuelve a crear con el nuevo código
    
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

    Rem Crea todo el script para el fichero javascripts
    
    Dim loadPackage As String
    Dim callDrawchart As String
    Dim addRows As Collection
    Dim funcDrawChart As String
    Dim options As String
    Dim var_chart As String
    Dim chart As String
    
    loadPackage = "google.charts.load('current', {'packages':['corechart']});"
    callDrawchart = "google.charts.setOnLoadCallback(drawChart);"
    
    Set addRows = converterRecordsetToCollection(headColumn, table, includeHead)
    funcDrawChart = drawChartForJavascript(addRows)
    
    If customChart <> Empty Then
        optionVisualization = formatString("var options = {0};", customChart)
    End If
    
    var_chart = formatString("var chart = new google.visualization.{0}(document.getElementById('chart_div'));", typeChart)
    chart = "chart.draw(data, options);" & vbCrLf & "}"
    
    
    writeJavascript = formatString(loadPackage + "{0}" + callDrawchart + "{0}" + funcDrawChart + "{0}{1}{1}" + optionVisualization + "{0}{1}{1}" + var_chart + "{0}{1}{1}" + chart, _
                    vbCrLf, BLANK)
                    
End Function

Public Function converterRecordsetToCollection(ByRef fields(), ByVal table As String, Optional includeHead = False) As Collection
    Rem covierte el recordset a un collección inlcuyendole llavas al inicio y final de cada item
    Dim rs As Recordset
    Dim sql As String
    Dim addRows As New Collection
    Dim rowValues As String
    Dim columnNames As String

    sql = "SELECT " & Join(fields, ",") & " FROM " & table
        
    Set rs = CurrentDb.OpenRecordset(sql)
    
    With rs
        If .EOF And .BOF Then
            Debug.Print "No hay registros"
        Else
            'crea cabeceras en el primer indice de la colección
            If includeHead Then
            
                columnNames = "['" & Join(fields, "','") & "']"
                addRows.Add columnNames

            End If
            
            'carga el los datos del recordset
            .MoveFirst
            Do While Not (.EOF)
                rowValues = Empty
                
                For i = 0 To UBound(fields)
                
                    If i = 0 Then
                        rowValues = rowValues & "'" & .fields(fields(i)).Value & "'"
                    Else
                        rowValues = rowValues & .fields(fields(i)).Value
                    End If
                    
                    If i < UBound(fields) Then
                        rowValues = rowValues & ","
                    End If
                    
                Next i
                
                addRows.Add "[" & rowValues & "]"
                .MoveNext
            Loop
        End If
    End With
    
    Set converterRecordsetToCollection = addRows
End Function

Private Function formatString(ByVal text As String, ParamArray values()) As String
    
    Rem formatea la cadena que se le pase con los valores, esta cadena debe contener marcas como '{0}'
    
    Dim i As Integer
    
    For i = LBound(values) To UBound(values)
        text = Replace(text, "{" & i & "}", values(i))
    Next i
    
    formatString = text
    
End Function

Private Function drawChartForJavascript(ByRef addRows As Collection) As String
    
    Rem Esta función replica la función en JAVASCRIPT para cargar el array con la
    Rem información de msaccess
    
    Dim funcJavascript As String
    Dim arrToJs As String
    
    arrToJs = converterCollectionToString(addRows)
    
    If includeHead Then
        funcJavascript = formatString( _
                                    "function drawChart() {{0}{1}{1}  var data = google.visualization.arrayToDataTable([{0}{2}{0}]);" _
                                    , vbCrLf, BLANK, arrToJs)
                                    
    Else
        funcJavascript = formatString( _
                                    "function drawChart() {{1}{0}{0}var data = new google.visualization.DataTable();{1}{0}{0}data.addColumn('string', '{2}');{1}{0}{0}data.addColumn('number', '{3}');{1}{0}{0}data.addRows([{1}{0}{0}{0}{0}{4}{1}{0}{0}]);" _
                                    , BLANK, vbCrLf, headColumn(0), headColumn(1), arrToJs)
                                    
    End If
    
    drawChartForJavascript = funcJavascript
End Function

Private Function converterCollectionToString(ByRef arrCollection As Collection) As String
    
    Rem chr(9) = TAB
    Dim arrToJs As String
    Dim i As Integer
    
    For i = 1 To arrCollection.Count
        If i = 1 Then
            arrToJs = Chr(9) & arrCollection.Item(i)
        Else
            arrToJs = arrToJs & "," & vbCrLf & Chr(9) & arrCollection.Item(i)
        End If
    Next i
    
    converterCollectionToString = arrToJs
    
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

Rem propiedades que devuelven una constante para el cambiar el tipo de gráfico
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
Public Property Let addHead(ByRef arrHead() As Variant)
    headColumn = arrHead
End Property

Rem propiedades inicializadas al instanciar un objeto de esta clase
Private Sub Class_Initialize()

    With Me
        .typeChart = BARCHART_C
        optionVisualization = formatString("var options = {0}", OPTION_DEFAULT_CHART)
    End With
    
End Sub


