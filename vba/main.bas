Attribute VB_Name = "main"
Sub test1()
    Rem para visualizar los siguientes graficos
    Rem AreaChart | BarChart | ColumnChart | ComboChart | LineChart | SteppedAreaChart
    Rem es necesario cargar 2 campos
    
    Dim goChart As New ChartApiGoogle
    Dim arrHead() As Variant
    
    Rem creamos array con las cabeceras a enviar
    arrHead = Array("pais", "inflacion_en_2021")

    With goChart
        .addHead = arrHead                  'OBLIGATORIO:cargarmos nuestro array con las cabeceras
        .table = "Inflacion_2021"           'OBLIGATORIO:Enviamos el nombre de la tabla de donde sale la información
        .openWebChart                       'OBLIGATORIO:método ver gráfico en el navegador
    End With

End Sub
Sub test2()
    
    Rem para visualizar los siguientes graficos
    Rem BarChart | ColumnChart | ComboChart
    Rem es necesario cargar 3 campos
    
    Dim goChart As New ChartApiGoogle
    Dim var_option As String
    Dim arrHead() As Variant
    
    Rem creamos array con las cabeceras a enviar
    arrHead = Array("mes", "fenix", "disposed")
    
    'OPCIONAL:estos valores se pasaran para una personalización del grafico
    var_option = "{title : 'Gasto por proveedor',vAxis: {title: 'Soles'},hAxis: {title: 'Meses'},seriesType: 'bars',series: {2: {type: 'line'}}}"
    
    With goChart
        
        .addHead = arrHead                              'OBLIGATORIO:cargarmos nuestro array con las cabeceras
        .table = "gasto_por_proveedor"                  'OBLIGATORIO:Enviamos el nombre de la tabla de donde sale la información
        .customChart = var_option                       'OPCIONAL:Se pasan una cadena en formato JSON para personalizar el gráfico
        .includeHead = True                             'OPCIONAL:Solo para los graficos mencionados arriba debe establecer en 'True'
        .typeChart = .ComboChart                        'OPCIONAL: Cualquier de estos graficos BarChart | ColumnChart | ComboChart
        .openWebChart                                   'OBLIGATORIO:método ver gráfico en el navegador
    End With
    
End Sub
