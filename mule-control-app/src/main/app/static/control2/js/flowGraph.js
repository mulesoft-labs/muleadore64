var vis = d3.select('#top_div')
    .append('svg:svg')
      .attr('class', 'stage')
      .attr('width', '100%')
      .attr('height', '100%');

var nodes = [
  { 
    name: 'weather',
    x: 100,
    y: 50, 
    img: 'img/cloud2.png',
    imgHeight: 100,
    imgWidth: 100
  },
  { 
    name: 'twitter', 
    x: 100, 
    y: 200, 
    img: 'img/twitter.png',
    imgHeight: 100,
    imgWidth: 100
  },
  { 
    name: 'phone-app', 
    x: 100,
    y: 400, 
    img: 'img/phone.png',
    imgHeight: 100,
    imgWidth: 100
  },
  { 
    name: 'control-app', 
    x: 300,
    y: 200, 
    img: 'img/cloudhub-color.png',
    imgHeight: 100,
    imgWidth: 100,
    text: 'CloudHub app'
  },
  { 
    name: 'amq', 
    x: 500,
    y: 200, 
    img: 'img/message-queue-color.png',
    imgHeight: 100,
    imgWidth: 100,
    text: 'Anypoint MQ'
  },
  { 
    name: 'pi', 
    x: 720,
    y: 200, 
    img: 'img/pi.jpg',
    imgHeight: 200,
    imgWidth: 200,
    noBackground: true
  },
  { 
    name: 'c64', 
    x: 700,
    y: 400, 
    img: 'img/c64-real.png',
    imgHeight: 300,
    imgWidth: 300,
    noBackground: true
  },
  { 
    name: 'pi-mule', 
    x: 720,
    y: 80, 
    img: 'img/mule.png',
    imgHeight: 100,
    imgWidth: 100,
    noBackground: true
  },
  { 
    name: 'twitter-post',
    x: 900,
    y: 70, 
    img: 'img/twitter.png',
    imgHeight: 100,
    imgWidth: 100
  },
  { 
    name: 'lights', 
    x: 900,
    y: 200, 
    img: 'img/hue.png',
    imgHeight: 100,
    imgWidth: 100
  }

];

var circleSelector = vis.selectAll('circle.node');
var linkSelector = vis.selectAll('.link');

function refreshGraph(routes) {
 linkSelector = linkSelector
        .data(routes, (d) => d.id);
  linkSelector
        .enter().append('line')
          .attr('class', 'link')
          .attr('stroke', (d) => d.isActive ? 'blue' : '#ddd')
          .attr('fill', (d) => d.isActive ? 'blue' : '#ddd')
          .attr('stroke-width', (d) => 6)
          .attr('x1', function(d) { return d.source.x })
          .attr('y1', function(d) { return d.source.y })
          .attr('x2', function(d) { return d.target.x })
          .attr('y2', function(d) { return d.target.y });
  linkSelector.exit().remove();
  
  circleSelector = circleSelector.data(nodes, (d) => d.name);
  circleSelector.exit().remove();
 
  var node = circleSelector
      .enter().append('g')
      .attr('class', 'node');
  node
      .append('svg:circle')
      .attr('cx', (d) => d.x)
      .attr('cy', (d) => d.y)
      .attr('r', (d) => d.noBackground ? 0 : d.imgWidth / 2)
      .attr('fill', '#fff')
  node
      .append('image')
      .attr('xlink:href', (d) => d.img)
      .attr('x', (d) => d.x - d.imgWidth / 2)
      .attr('width', (d) => d.imgWidth)
      .attr('height', (d) => d.imgHeight)
      .attr('y', (d) => d.y - d.imgHeight / 2);
  

    // //TEXT
    node.append('text')
      .text((d) => d.text)
      .attr('x', (d) => d.x - d.imgWidth / 2)
      .attr('y', (d) => d.y + d.imgHeight / 2 + 20)
      .attr('fill',         function(d, i) {  return  '#000';  })
      .attr('font-size',    function(d, i) {  return  '1.5em'; })
      .attr('text-anchor',  function(d, i) { if (i>0) { return  'beginning'; }      else { return 'end' } })
    
}

var defaultColor = '#ddd';
window.routes = [
  {id: 'weatherToMule', source: nodes[0], target: nodes[3]},
  {id: 'twitterToMule', source: nodes[1], target: nodes[3]},
  {id: 'controlAppToMule', source: nodes[2], target: nodes[3]},
  {id: 'muleToAmq', source: nodes[3], target: nodes[4]},
  {id: 'amqToPi', source: nodes[4], target: nodes[5]},
  {id: 'piToC64', source: nodes[5], target: nodes[6]},
  {id: 'piToTwitter', source: nodes[7], target: nodes[8]},
  {id: 'piToLights', source: nodes[7], target: nodes[9]}
];     

refreshGraph(window.routes);

