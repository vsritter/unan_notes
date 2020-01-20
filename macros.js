
remark.macros.scale = function (percentage) {
  var url = this;
  return '<img src="' + url + '" style="width: ' + percentage + '" />';
};

remark.macros.border = function () {
  var url = this;
  return '<img src="' + url + '" style="border: 1px solid black" />';
};

