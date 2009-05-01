/*global Ext */
/*global WebCritic */
Ext.ns('WebTest');
WebCritic.Grid = Ext.extend(Ext.grid.GridPanel, {
      initComponent: function () {
         var config = {
            store: new Ext.data.Store({
                  proxy: new Ext.data.HttpProxy({
                        url: 'test/controller/tests',
                        timeout: 1800000
                     }),
                  sortInfo: {
                     field: 'number',
                     direction: 'DESC'
                  },
                  reader: new Ext.data.JsonReader({
                        root: 'data'
                     }, [
                     'is_ok', 'explanation',
                     'number', 'description',
                     'explanation', 'is_unplanned',
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
               header: 'File',
               dataIndex: 'filename',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
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
               width: 200
            }, {
               header: 'Explanation',
               dataIndex: 'explanation',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
            }, {
               header: 'Description',
               dataIndex: 'description',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
            }, {
               header: 'Planned',
               dataIndex: 'is_planned',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
            }, {
               header: 'Skip',
               dataIndex: 'has_skip',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
            }, {
               header: 'Todo',
               dataIndex: 'has_todo',
               renderer: function(value, metadata, record) {
                  metadata.attr += 'style="color: grey;"';
                  return value;
               },
               sortable: true,
               width: 200
            }]
         };
         Ext.apply(this, Ext.apply(this.initialConfig, config));
         WebCritic.Grid.superclass.initComponent.apply(this, arguments);
      }
   });

Ext.reg('test_grid', WebTest.Grid);
