HTMLWidgets.widget({

  name: 'hierplane',

  type: 'output',

  factory: function(el, width, height) {

    var elementId = "#" + el.id;

    return {

      renderValue: function(x, el) {

        hierplane.renderTree(x.tree, { target: elementId, theme: x.theme });

      },

      resize: function(width, height) {

      }

    };
  }
});
