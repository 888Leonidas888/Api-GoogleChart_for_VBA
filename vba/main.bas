Attribute VB_Name = "main"
Sub main()
    
    Dim goChart As New ChartApiGoogle
    
    With goChart
        'rem estos campos son obtenidos de la tabla y también debe pasarse la tabla de donde se extraerá los datos
        Rem propiedades obligatorias
        .headString = "pais"                '--cabeceras tipo cadena
        .headNumber = "Inflacion_en_2021"   '--datos númericos
        .table = "Inflacion_2021"           '--nombre de la tabla de access
        
        
        Rem propiedades opcionales
        .typeChart = .ColumnChart           '--tipo de grafico a mostrar
                                            'valor x defecto PieChart
                                            'otros tipos(AreaChart / BarChart / ColumnChart / ComboChart / LineChart / SteppedAreaChart)
                                            
        '.eightChart = 300                  'alto del grafico valor x defecto 600
        .widthChart = 960                   'ancho del grafico valor x defecto 800
        '.title = "Inflación"               'titulo del grafico
        
        'muestra el grafico en el navegador por defecto en Chrome
        .openWebChart
    End With

End Sub
