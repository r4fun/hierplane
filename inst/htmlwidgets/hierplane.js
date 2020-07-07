HTMLWidgets.widget({

  name: 'hierplane',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {
        // tree object, json
        const tree = x.tree;
        hierplane.renderTree(tree);

      },

      resize: function(width, height) {

      }

    };
  }
});
