
var data = undefined;

var chartsVars = {
  'bar_chart': {
    'x': 'X val',
    'y': 'Y val'
  },
  'soccer_field': {
    'x'    : 'X pos',
    'y'    : 'Y pos',
    'color': 'Color',
    'size' : 'Size'
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
  var element = '#script_graph';
  switch(chartType) {
    case 'bar_chart':
      barChart(element);
      break;
    case 'soccer_field':
      soccerField(element);
      break;
  }
};

/**
 * Bar chart.
 */
var barChart = function(element) {
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
 * Soccer field.
 */
var soccerField = function (element) {
      var xColumn     = undefined;
      var yColumn     = undefined;
      var sizeColumn  = undefined;
      var colorColumn = undefined;

      var chartVars = $('.chart_vars_choice').each(function(index, current) {
        if(current.value != "") {
          var column = current.id.substring(4);
          if(current.value == 'x') {
            xColumn = column;
          }
          if(current.value == 'y') {
            yColumn = column;
          }
          if(current.value == 'size') {
            sizeColumn = column;
          }
          if(current.value == 'color') {
            colorColumn = column;
          }
        }
      });

      // Title
      var elemTitle = d3.select(element)
          .append("p")
          .attr("class", "title")
          .style({
              "font-weight":   "bold",
              "text-align":    "center",
              "margin-bottom": "20px"
          })
          //.text("fig. 1 - ExpG selon la position du tir")
          ;

      var margin = {top: 0, right: 0, bottom: 0, left: 0},
      width = 600 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

      var x = d3.scaleLinear()
          .range([0, width]);

      var y = d3.scaleLinear()
          .range([height, 0]);

      /** Teams colors **/

      // Angers home
      var awayTeamFill   = "#FFF";
      var awayTeamStroke = "#000";

      // Rennes home
      var homeTeamFill   = "#FF0000";
      var homeTeamStroke = "#000";

      // Nice home
      var awayTeamFill   = "#000";
      var awayTeamStroke = "#F00";

      var xAxis = d3.axisBottom(x);

      var yAxis = d3.axisLeft(y);

      var legend = d3.select(element).append("ul").attr("class", "legend");

      var svg = d3.select(element).append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      var rectangle = svg.append("rect")
                            .attr("x",   0)
                              .attr("y", 0)
                              .attr("width", width)
                              .attr("height", height)
                              .attr("fill", "#00FF7F");

      var fieldStartX = 20;
      var fieldStartY = 20;
      var fieldWidth = width - fieldStartX * 2;
      var fieldHeight = height - fieldStartY * 2;

      // Grass graph
      var grassStep = width/10;
      for(var i=0 ; i<width ; i=i+grassStep) {
        if((i/grassStep)%2 == 0) {
          var rectangle = svg.append("rect")
                                .attr("x",   i)
                                  .attr("y", 0)
                                  .attr("width", grassStep+"px")
                                  .attr("height", height)
                                  .attr("fill", "#32CD32");
        }
      }

      var lineData = [ // The field lines
                       {"x": fieldStartX,             "y": fieldStartY},
                       {"x": fieldStartX+fieldWidth,  "y": fieldStartY},
                       {"x": fieldStartX+fieldWidth,  "y": fieldStartY+fieldHeight},
                       {"x": fieldStartX,             "y": fieldStartY+fieldHeight},
                       {"x": fieldStartX,             "y": fieldStartY},
                       // Penalty area 1
                       {"x": fieldStartX,                   "y": fieldStartY+(fieldHeight/4.77)},
                       {"x": fieldStartX+(fieldWidth*0.17), "y": fieldStartY+(fieldHeight/4.77)},
                       {"x": fieldStartX+(fieldWidth*0.17), "y": fieldStartY+(fieldHeight/1.26)},
                       {"x": fieldStartX,                   "y": fieldStartY+(fieldHeight/1.26)},
                       // Goalkeeper area 1
                       {"x": fieldStartX,                    "y": fieldStartY+(fieldHeight/2.71)},
                       {"x": fieldStartX+(fieldWidth*0.05),  "y": fieldStartY+(fieldHeight/2.71)},
                       {"x": fieldStartX+(fieldWidth*0.05),  "y": fieldStartY+(fieldHeight/1.58)},
                       {"x": fieldStartX,                    "y": fieldStartY+(fieldHeight/1.58)},
                       // Goal 1
                       {"x": fieldStartX,                   "y": fieldStartY+(fieldHeight/2.27)},
                       {"x": fieldStartX-(fieldWidth/112),  "y": fieldStartY+(fieldHeight/2.27)},
                       {"x": fieldStartX-(fieldWidth/112),  "y": fieldStartY+(fieldHeight/1.79)},
                       {"x": fieldStartX,                   "y": fieldStartY+(fieldHeight/1.79)},
                       // Midfield
                       {"x": fieldStartX,                   "y": fieldStartY},
                       {"x": fieldStartX+(fieldWidth/2),    "y": fieldStartY},
                       {"x": fieldStartX+(fieldWidth/2),    "y": fieldStartY+(fieldHeight)},
                       {"x": fieldStartX+fieldWidth,        "y": fieldStartY+fieldHeight},
                       // Penalty area 2
                       {"x": fieldStartX+fieldWidth,                   "y": fieldStartY+(fieldHeight/4.77)},
                       {"x": fieldStartX+(fieldWidth-fieldWidth*0.17), "y": fieldStartY+(fieldHeight/4.77)},
                       {"x": fieldStartX+(fieldWidth-fieldWidth*0.17), "y": fieldStartY+(fieldHeight/1.26)},
                       {"x": fieldStartX+fieldWidth,                   "y": fieldStartY+(fieldHeight/1.26)},
                       // Goalkeeper area 2
                       {"x": fieldStartX+fieldWidth,                    "y": fieldStartY+(fieldHeight/2.71)},
                       {"x": fieldStartX+(fieldWidth-fieldWidth*0.05),  "y": fieldStartY+(fieldHeight/2.71)},
                       {"x": fieldStartX+(fieldWidth-fieldWidth*0.05),  "y": fieldStartY+(fieldHeight/1.58)},
                       {"x": fieldStartX+fieldWidth,                    "y": fieldStartY+(fieldHeight/1.58)},
                       // Goal 2
                       {"x": fieldStartX+fieldWidth,                   "y": fieldStartY+(fieldHeight/2.27)},
                       {"x": fieldStartX+(fieldWidth+fieldWidth/112),  "y": fieldStartY+(fieldHeight/2.27)},
                       {"x": fieldStartX+(fieldWidth+fieldWidth/112),  "y": fieldStartY+(fieldHeight/1.79)},
                       {"x": fieldStartX+fieldWidth,                   "y": fieldStartY+(fieldHeight/1.79)},];
      var lineFunction = d3.line()
                               .x(function(d) { return d.x; })
                               .y(function(d) { return d.y; })
                               //.interpolate("linear")
                               ;
      var lineGraph = svg.append("path")
                          .attr("d", lineFunction(lineData))
                          .attr("stroke", "#FFF")
                          .attr("stroke-width", 2)
                          .attr("fill", "none");

      // The center circle
      var circleSelection = svg.append("circle")
                           .attr("cx", fieldStartX+(fieldWidth/2))
                           .attr("cy", fieldStartY+(fieldHeight/2))
                           .attr("r", 50)
                           .style("stroke-opacity", 1)
                           .style("stroke-width", 2)
                           .style("fill-opacity", 0)
                           .style("fill", "#FFF")
                           .style("stroke", "#FFF");

      // The engaging point
      var circleSelection = svg.append("circle")
                           .attr("cx", fieldStartX+(fieldWidth/2))
                           .attr("cy", fieldStartY+(fieldHeight/2))
                           .attr("r", 2)
                           .style("stroke-opacity", 1)
                           .style("stroke-width", 2)
                           .style("fill-opacity", 1)
                           .style("fill", "#FFF")
                           .style("stroke", "#FFF");

      // The penalty area circle arc 1
      svg.append("path")
                    .attr("d", "M "+(fieldStartX+(fieldWidth*0.17))+","+(fieldStartY+(fieldHeight/2.53))+
                              " A 80,80 0 0,1"+
                                " "+(fieldStartX+(fieldWidth*0.17))+","+(fieldStartY+(fieldHeight/1.65)))
                    .style("stroke-opacity", 1)
                    .style("stroke-width", 2)
                    .style("fill-opacity", 0)
                    .style("stroke", "#FFF");

      // The penalty area circle arc 2
      svg.append("path")
             .attr("d", "M "+(fieldStartX+(fieldWidth-fieldWidth*0.17))+","+(fieldStartY+(fieldHeight/2.53))+
                       " A 80,80 0 0,0"+
                         " "+(fieldStartX+(fieldWidth-fieldWidth*0.17))+","+(fieldStartY+(fieldHeight/1.65)))
             .style("stroke-opacity", 1)
             .style("stroke-width", 2)
             .style("fill-opacity", 0)
             .style("stroke", "#FFF");

      // The penalty point 1
      var circleSelection = svg.append("circle")
                           .attr("cx", fieldStartX+(fieldWidth/9))
                           .attr("cy", fieldStartY+(fieldHeight/2))
                           .attr("r", 2)
                           .style("stroke-opacity", 1)
                           .style("stroke-width", 2)
                           .style("fill-opacity", 1)
                           .style("fill", "#FFF")
                           .style("stroke", "#FFF");

      // The penalty point 2
      var circleSelection = svg.append("circle")
                           .attr("cx", fieldStartX+(fieldWidth-fieldWidth/9))
                           .attr("cy", fieldStartY+(fieldHeight/2))
                           .attr("r", 2)
                           .style("stroke-opacity", 1)
                           .style("stroke-width", 2)
                           .style("fill-opacity", 1)
                           .style("fill", "#FFF")
                           .style("stroke", "#FFF");

       // The corner 1 arc
       svg.append("path")
                     .attr("d", "M "+(fieldStartX+5)+","+(fieldStartY)+
                               " A 5,5 0 0,1"+
                                 " "+(fieldStartX)+","+(fieldStartY+5))
                     .style("stroke-opacity", 1)
                     .style("stroke-width", 2)
                     .style("fill-opacity", 0)
                     .style("stroke", "#FFF");

        // The corner 2 arc
        svg.append("path")
               .attr("d", "M "+(fieldStartX+fieldWidth-5)+","+(fieldStartY)+
                         " A 5,5 0 0,0"+
                           " "+(fieldStartX+fieldWidth)+","+(fieldStartY+5))
               .style("stroke-opacity", 1)
               .style("stroke-width", 2)
               .style("fill-opacity", 0)
               .style("stroke", "#FFF");

        // The corner 3 arc
        svg.append("path")
         .attr("d", "M "+(fieldStartX+fieldWidth-5)+","+(fieldStartY+fieldHeight)+
                   " A 5,5 0 0,1"+
                     " "+(fieldStartX+fieldWidth)+","+(fieldStartY+fieldHeight-5))
         .style("stroke-opacity", 1)
         .style("stroke-width", 2)
         .style("fill-opacity", 0)
         .style("stroke", "#FFF");

      // The corner 4 arc
      svg.append("path")
       .attr("d", "M "+(fieldStartX+5)+","+(fieldStartY+fieldHeight)+
                 " A 5,5 0 0,0"+
                   " "+(fieldStartX)+","+(fieldStartY+fieldHeight-5))
       .style("stroke-opacity", 1)
       .style("stroke-width", 2)
       .style("fill-opacity", 0)
       .style("stroke", "#FFF");

      var hexbin = d3_hexbin.hexbin()
        //.size([fieldWidth, fieldHeight])
        .radius(10);

      //homeTeamId = data[0]["sqw_home_team_id"];

      x.domain([0, 100]).nice();
      y.domain([0, 100]).nice();

      // Grouping by team name
      /*
      var legendData = d3.nest()
       .key(function(d) { return d.short_name; })
       .rollup(function(d) {
         return {
           'team_id': d3.mean(d, function(g) { return g.team_id; }),
           'nb_shots': d.length,
           'goals': d3.sum(d, function(g) {return g.goal; }),
           'expg': d3.sum(d, function(g) {return g.predict; })
         };
       })
       .entries(data);

       // Home team is the first
       legendData.sort(function(a, b) {
         if(a.values.team_id == homeTeamId) {
           return 0;
         }
         return 1;
       });

      // Ajout de la légende
      var teamLegend = legend
         .selectAll("ul")
         .data(legendData)
         .enter()
           .append("li");

      teamLegend.append("h3")
             .style("text-align", function(d) {
               if(d.values.team_id == homeTeamId) {
                 return "right";
               }
               return "left";
             })
             .html( function(d) {
               if(d.values.team_id == homeTeamId) {
                 return d.key+" <strong>"+d.values.goals+"</strong>";
               }
               return "<strong>"+d.values.goals+"</strong> "+d.key;
             })
      teamLegend.append("p")
             .style("text-align", function(d) {
               if(d.values.team_id == homeTeamId) {
                 return "right";
               }
               return "left";
             })
             .html( function(d) {
               if(d.values.team_id == homeTeamId) {
                 return "<small>ExpG</small> "+Math.round(d.values.expg*100)/100;
               }
               return Math.round(d.values.expg*100)/100+" <small>ExpG</small>";
             });
      teamLegend.append("p")
             .style("text-align", function(d) {
               if(d.values.team_id == homeTeamId) {
                 return "right";
               }
               return "left";
             })
             .html( function(d) {
               if(d.values.team_id == homeTeamId) {
                 return "<small>Tirs</small> "+d.values.nb_shots;
               }
               return d.values.nb_shots+" <small>Tirs</small>";
             });
             */

      // Suppression des éléments
      svg.selectAll(".hexagon").remove();

      svg.append("clipPath")
        .attr("id", "clip")
      .append("rect")
        .attr("class", "mesh")
        .attr("width", width)
        .attr("height", height);

      // Ajout des éléments
      svg.append("g")
      .attr("clip-path", "url(#clip)")
      .selectAll(".hexagon")
      .data(data)
        .enter().append("path")
          .attr("class", "hexagon")
          .attr("d", function(d) { return hexbin.hexagon(d[sizeColumn] * 4); })
          .attr("transform", function(d) {
            var tr_x = x(d[xColumn]);
            var tr_y = y(d[yColumn]);
            return "translate(" + tr_x + "," + tr_y + ")";
          })
          .style("fill", function(d) {
            return d[colorColumn] || homeTeamFill;
          })
          .style("stroke", function(d) {
            return homeTeamStroke;
          })
          .style("stroke-width", function(d) {
            if(d.goal == 1) {
              return "1.6px";
            }
            return "0.8px";
          });
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
