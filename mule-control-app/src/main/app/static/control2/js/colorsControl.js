// colors taken from https://www.c64-wiki.com/index.php/Color
var colorsArray = [
                    { "color": "black", "hex": "#000000", "poke": 0 },
                    { "color": "white", "hex": "#FFFFFF", "poke": 1 },
                    { "color": "red", "hex": "#880000", "poke": 2 },
                    { "color": "cyan", "hex": "#AAFFEE", "poke": 3 },
                    { "color": "violet", "hex": "#CC44CC", "poke": 4 },
                    { "color": "green", "hex": "#00CC55", "poke": 5 },
                    { "color": "blue", "hex": "#0000AA", "poke": 6 },
                    { "color": "yellow", "hex": "#EEEE77", "poke": 7 },
                    { "color": "orange", "hex": "#DD8855", "poke": 8 },
                    { "color": "brown", "hex": "#664400", "poke": 9 },
                    // { "color": "lightred", "hex": "#FF7777", "poke": 10 },
                    // { "color": "grey1", "hex": "#333333", "poke": 11 },
                    // { "color": "grey2", "hex": "#777777", "poke": 12 },
                    // { "color": "lightgreen", "hex": "#AAFF66", "poke": 13 },
                    // { "color": "lightblue", "hex": "#0088FF", "poke": 14 },
                    // { "color": "grey3", "hex": "#BBBBBB", "poke": 15 },
                  ];

var Comment = React.createClass({

clickHandler: function clickHandler(e) {
 //var attribute = event.target.attributes.getNamedItem('data-colorattr');
 //console.log("Clicked a label, need to load up the messages dialog: " + attribute);
 console.log("Clicked a label, need to load up the messages dialog: " + JSON.stringify(this.props));
 sendColor(this.props.name, this.props.hex, this.props.poke);
},

render: function() {
 //var divStyle = { color: this.props.hex };
 var divStyle = { backgroundColor: this.props.hex };

 return (
   <button className="colorclickdiv" onClick={ this.clickHandler } style={divStyle} data-colorattr={this.props.name} >
   </button>
 );
}
});


var CommentList = React.createClass({
render: function() {
 var commentNodes = this.props.data.map(function(comment) {
   return (
     <Comment name={comment.color} key={comment.poke} hex={comment.hex} poke={comment.poke}>
       {comment.color}
     </Comment>
   );
 });
 return (
   <div className="commentList">
     {commentNodes}
   </div>
 );
}
});


// tutorial9.js
var CommentBox = React.createClass({
render: function() {
 return (
   <div className="commentBox">
     <CommentList data={this.props.data} />
   </div>
 );
}
});

ReactDOM.render(
<CommentBox data={colorsArray} />,
document.getElementById('colorcontent')
);


function sendColor(newColor, hex, poke) {

//var colorAttr = $(elementObj).attr('data-colorattr');
console.log("In sendColor with value: " + newColor);

var colorType = "border";
if($("#backgroundbtn").hasClass("btn-muleadorepri")) {
 colorType = "background";
}

var data = {
 colortype: colorType,
 color: newColor,
 hex: hex,
 poke: poke
};

$.ajax({
 type: "POST",
 url: baseUrl + "/api/color",
 data: data,
 //dataType: 'text/html',
 success: function(data, textStatus, jqXHR) {
   //data - response from server
    toastr.options.hideDuration = 0;
    toastr.remove();
    toastr.options.hideDuration = 1000;
    var $toast = toastr.success('Colour change has been sent!')
 },
 error: function (jqXHR, textStatus, errorThrown) {
    toastr.options.hideDuration = 0;
    toastr.remove();
    toastr.options.hideDuration = 1000;
    var $toast = toastr.error('Unable to set colour')
    console.log(errorThrown);
 }
});

}