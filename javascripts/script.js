google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawChart);
function drawChart() {
  var data = new google.visualization.DataTable();
  data.addColumn('string', 'pais');
  data.addColumn('number', 'Inflacion_en_2021');
  data.addRows([
    ['Argentina',48.8],
    ['Bolivia',1.7],
    ['Brasil',9.68],
    ['Chile',4.4],
    ['Colombia',4.56],
    ['Costa Rica',1.67],
    ['Cuba',61.7],
    ['Ecuador',0.98],
    ['El Salvador',2.2],
    ['Guatemala',3.98],
    ['Haití',23.6],
    ['Honduras',5.67],
    ['México',6.08],
    ['Nicaragua',7.2],
    ['Panamá',1.11],
    ['Paraguay',2.23],
    ['Perú',3.56],
    ['República Dominicana',8.8],
    ['Uruguay',9.52],
    ['Venezuela',80]
  ]);
  var options = {'title':'Gráfico generado para Access','width':960,'eight':600};
  var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
  chart.draw(data, options);
}