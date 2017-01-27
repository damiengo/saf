
$(document).ready(function() {
  $.ajax({
      type: "GET",
      url: "bet_odds",
      dataType: "JSON"
  }).success(function(json) {
    showTable(json.odds);
  });
});

/**
 * Displays results in table.
 *
 * @param data
 */
var showTable = function(data) {
  var element = '#odds';
  $(element).empty();
  var table = d3.select(element).append("table");
  // Set columns and colors
  var colorRange = colorbrewer.Reds[9];
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
