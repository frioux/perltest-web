/*global Ext */
/*global WebTest */
Ext.ns('WebTest');

WebTest.passRenderer = function (value, metadata, record) {
   if (value) {
      metadata.css += ' true-value ';
   }
   return "";
};

WebTest.passFailRenderer = function (value, metadata, record) {
   if (value) {
      metadata.css += ' true-value ';
   } else {
      metadata.css += ' false-value ';
   }
   return "";
};

WebTest.Grid = Ext.extend(Ext.grid.GridPanel, {
      initComponent: function () {
         var config = {
            store: new Ext.data.Store({
                  proxy: new Ext.data.HttpProxy({
                        url: 'test/controller/tests',
                        timeout: 1800000
                     }),
                  sortInfo: {
                     field: 'filename',
                     direction: 'ASC'
                  },
                  reader: new Ext.data.JsonReader({
                        root: 'data'
                     }, [
                     'is_ok', 'explanation',
                     'number', 'description',
                     'explanation', 'is_planned',
                     'has_skip', 'has_todo', 'filename'
                  ]
               )
            }),
         columns: [{
               header: 'Number',
               dataIndex: 'number',
               sortable: true,
               width: 60
            }, {
               header: 'Passed?',
               dataIndex: 'is_ok',
               renderer: function(value, metadata, record) {
                  if (value) {
                     metadata.attr += 'style="color: grey;"';
                     return 'Passed';
                  } else {
                     metadata.attr += 'style="color: red;"';
                     return 'Failed';
                  }
               },
               sortable: true,
               width: 50
            }, {
               header: 'File',
               dataIndex: 'filename',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
            }, {
               header: 'Explanation',
               dataIndex: 'explanation',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               hidden: true,
               width: 200
            }, {
               header: 'Description',
               dataIndex: 'description',
               renderer: function(value, metadata, record) {
                  if (record.get('is_ok')) {
                     metadata.attr += 'style="color: grey;"';
                  } else {
                     metadata.attr += 'style="color: red;"';
                  }
                  return value;
               },
               sortable: true,
               width: 200
            }, {
               header: 'Planned',
               dataIndex: 'is_planned',
               renderer: function (value, metadata, record) {
                  if ( value || ( !value && ( record.get('has_todo') || record.get('has_skip') ) ) ) {
                     metadata.css += ' true-value ';
                  } else {
                     metadata.css += ' false-value ';
                  }
               },
               sortable: true,
               width: 50
            }, {
               header: 'Skip',
               dataIndex: 'has_skip',
               renderer: function (value, metadata, record) {
                  WebTest.passRenderer(value, metadata, record);
                  metadata.attr += ' background-position: left; style="color: grey;"';
                  if (value) {
                     return String.format("<span style='padding-left: 20px;'>{0}</span>", record.get('explanation'));
                  }
               },
               sortable: true,
               width: 200
            }, {
               header: 'Todo',
               dataIndex: 'has_todo',
               renderer: function (value, metadata, record) {
                  WebTest.passRenderer(value, metadata, record);
                  metadata.attr += ' background-position: left; style="color: grey;"';
                  if (value) {
                     return String.format("<span style='padding-left: 20px;'>{0}</span>", record.get('explanation'));
                  }
               },
               sortable: true,
               width: 200
            }]
         };
         Ext.apply(this, Ext.apply(this.initialConfig, config));
         WebTest.Grid.superclass.initComponent.apply(this, arguments);
      }
   });

Ext.reg('test_grid', WebTest.Grid);
