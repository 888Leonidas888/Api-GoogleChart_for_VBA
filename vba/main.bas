Attribute VB_Name = "main"
Sub test1()
    
    Dim goChart As New ChartApiGoogle

    With goChart
        ' estos campos son obtenidos de la tabla y también debe pasarse la tabla de donde se extraerá los datos
        ' propiedades obligatorias
        .headString = "pais"                '--cabeceras tipo cadena
        .headNumber = "Inflacion_en_2021"   '--datos númericos
        .table = "Inflacion_2021"           '--nombre de la tabla de access
        
        Rem propiedades opcionales
        'valor x defecto PieChart
        'tipos compatibles (AreaChart | BarChart | ColumnChart | ComboChart | LineChart | SteppedAreaChart)
'        .typeChart = .BarChart
                                                                           
        'muestra el grafico en el navegador por defecto en Chrome
        .openWebChart
    End With

End Sub
Sub test2()

    Dim goChart As New ChartApiGoogle
    Dim var_option As String
    
    'estos valores se pasaran para una personalización del grafico es opcional
    var_option = "{title : 'Gasto por proveedor',vAxis: {title: 'Soles'},hAxis: {title: 'Meses'},seriesType: 'bars',series: {2: {type: 'line'}}}"
    
    With goChart
        
        'Este tipo de grafico se le debe invocar pasando las 4 propiedades siguientes
        .headString = "mes"
        .headNumber = "fenix"
        .headNumber1 = "disposed"
        .table = "gasto_por_proveedor"
        
        'personalice el gráfico, pasando las opciones en formato JSON
        .customChart = var_option
        
        ' 2 posibles formas de invocar [drawChart|drawVisualization]
        .modeChart = 2
        
        Rem propiedades opcionales
        'tipo de grafico a mostrar
        'otros tipos compatibles (BarChart|ColumnChart|ComboChart)
        .typeChart = .BarChart
                                            
        'muestra el grafico en el navegador por defecto en Chrome
        .openWebChart
    End With
    
End Sub
