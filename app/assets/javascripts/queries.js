
var data = undefined;

var chartsVars = {
  'bar_chart': {
    'x': 'X val',
    'y': 'Y val'
  }
};

$(document).ready(function() {
  bindForm();
  $('#chosse_chart').click(function(e) {
    getDataVars($('#graph_type').val());
  });
});

/**
 * Prepares form events binding.
 */
var bindForm = function() {
  $('#choose_script').submit(function() {
    var valuesToSubmit = $(this).serialize();
    $.ajax({
        type: "GET",
        url: $(this).attr('action'), //sumbits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
    }).success(function(json){
      data = json.script_results;
      showScript(json);
    });

    return false;
  });
};

/**
 * Shows a script.
 *
 * @param json
 */
var showScript = function(json) {
  $('#script_content').html(json.script_content);
  showResultsInTable(json.script_results);
}

/**
 * Displays results in table.
 *
 * @param results
 */
var showResultsInTable = function(results) {
  var data = results;
  if(data.length > 100) {
    data = data.slice(0, 100);
  }

  var element = '#script_results';
  $(element).empty();
  var table = d3.select(element).append("table");
  // Set columns and colors
  var colorRange = colorbrewer.Blues[6];
  var colors  = [];
  var columns = [];
  if(data.length > 0) {
    for(var i in data[0]) {
      columns.push(i);
      if(parseFloat(data[0][i])) {
        colors[i] = d3.scaleQuantize()
                       .domain(d3.extent(data, function(d) { return parseFloat(d[i]); }))
                       .range(colorRange);
      }
    }
  }

  var thead = table.append("thead");
  var tbody = table.append("tbody");

  // append the header row
  thead.append("tr")
      .selectAll("th")
      .data(columns)
      .enter()
      .append("th")
          .text(function(column) { return column.replace(/_/g, ' '); });

  // create a row for each object in the data
  var rows = tbody.selectAll("tr")
      .data(data)
      .enter()
      .append("tr");

  rows.selectAll("td")
    .data(function(row) {
        return columns.map(function(column) {
            return {'column': column, 'value': row[column]};
        });
    })
    .enter()
    .append("td")
        .html(function(d) {
          return d.value;
        })
    .style("background-color", function(d) {
      var color = colors[d.column];
      if(color) {
        return color(d.value);
      }
    })
    .style("color", function(d) {
      var color = colors[d.column];
      if(color) {
        // Set color from backgroud
        var rgb = hexToRgb(color(d.value));
        if((rgb.r*0.299 + rgb.g*0.587 + rgb.b*0.114) > 186) {
          return "#000";
        }
        else {
          return "#FFF";
        }
      }
      return "#000";
    });
};

/**
 * Get the data vars.
 *
 * @param chartType
 */
var getDataVars = function(chartType) {
  var element = $('#graph_vars');
  element.empty();
  if(data.length > 0) {
    for(var i in data[0]) {
      var elementHtml = '';
      if(chartsVars[chartType]) {
        elementHtml += '<li><select class="chart_vars_choice" id="for_'+i+'"><option value=""></option>';
        for(var j in chartsVars[chartType]) {
          elementHtml += '<option value="'+j+'">'+chartsVars[chartType][j]+'</option>';
        }
        elementHtml += '</select>';
      }
      element.append('<label>'+elementHtml+' '+i+'</label></li>')
    }
    element.append('<input type="submit" id="submit_chart_vars" value=" OK " />');
    $('#submit_chart_vars').click(function(e) {
      showChart(chartType);
    });
  }
};

/**
 * Shows a chart.
 *
 * @param chartType
 */
var showChart = function(chartType) {

  var xColumn = undefined;
  var yColumn = undefined;

  var chartVars = $('.chart_vars_choice').each(function(index, current) {
    if(current.value != "") {
      var column = current.id.substring(4);
      if(current.value == 'x') {
        xColumn = column;
      }
      if(current.value == 'y') {
        yColumn = column;
      }
    }
  });

  var element = '#script_graph';
  var margin = {top: 20, right: 20, bottom: 40, left: 40},
  width = 800 - margin.left - margin.right,
  height = 500 - margin.top - margin.bottom;

  var firstLine = data[0];

  if(parseFloat(firstLine[xColumn])) {
    var x = d3.scaleLinear()
              .domain(d3.extent(data, function(d) { return d[xColumn]; })).nice()
              .range([0, width]);
  }
  else {
    var x = d3.scaleBand()
        .domain(data.map(function(d) { return d[xColumn]; }))
        .rangeRound([0, width]);
  }

  if(parseFloat(firstLine[xColumn])) {
    var y = d3.scaleLinear()
              .domain(d3.extent(data, function(d) { return d[yColumn]; })).nice()
              .range([0, height]);
  }
  else {
    var y = d3.scaleBand()
        .domain(data.map(function(d) { return d[yColumn]; }))
        .rangeRound([0, height]);
  }

  var xAxis = d3.axisBottom(x);

  var yAxis = d3.axisLeft(y);

  var svg = d3.select(element).append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", -35)
      .attr("x", -2)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("PDO");

    svg.selectAll(".x.axis text")
        .style("text-anchor", "end")
        .attr("dx", "-.8em")
        .attr("dy", ".15em")
        .attr("transform", function(d) {
            return "rotate(-30)";
      });

    var bar = svg.selectAll(".bar")
        .data(data)
      .enter().append("g");

    bar.append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d[xColumn]); })
        .attr("width", 20)
        .attr("y", function(d) { return y(d[yColumn]); })
        .attr("height", function(d) { return height - y(d[yColumn]); })
        .style("fill", "steelblue");

};

/**
 * Convert HEX color to RGB.
 *
 * @param hex
 *
 * @return Array
 */
var hexToRgb = function(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
};
