(function() {
    Backbone.BatchCollection = Backbone.Collection.extend({
        isNew: function() {
            var isNew = this.all(function(model) {
                return !_.has(model, 'id');
            });
            return isNew;
        },
        isChanged: function() {
            var isChanged = this.some(function(model) {
                return model.hasChanged();
            });
            return isChanged;
        },
        save: function(options) {
            // initialize options
            if (_.isUndefined(options)) {
                options = {};
            }
            _.defaults(options, {
                url: this.url,
                contentType: 'application/json',
                silent: false,
                data: this.toJSON()
            });

            // check collection status
            if (this.isEmpty()) {
                this.batchDelete(options);
            }
            else if (this.isNew()) {
                this.batchAdd(options);
            }
            else {
                this.batchUpdate(options);
            }
        },
        batch: function(options) {
        	
        	// fire beforerequest event            
            this.trigger('beforerequest', options.data);
            
            // create parameters
            var ajaxOptions = {
                type: options.type,
                url: options.url,
                data: JSON.stringify(options.data),
                contentType: options.contentType,
                context: this
            };

            // batch update models
            jQuery.ajax(ajaxOptions).done(function(res) {
                if (!options.silent) {
                    this.trigger('sync', this.models);
                }
            });

            // fire request event
            if (!options.silent) {
                this.trigger('request', this.models);
            }

        },
        batchDelete: function(options) {
            if (_.isUndefined(options.type)) {
                options.type = 'PUT';
            }
            this.batch(options);
        },
        batchUpdate: function(options) {
            if (_.isUndefined(options.type)) {
                options.type = 'PUT';
            }
            this.batch(options);
        },
        batchAdd: function(options) {
            if (_.isUndefined(options.type)) {
                options.type = 'POST';
            }
            this.batch(options);
        }
    });

    _.extend(Backbone.BatchCollection.prototype, Backbone.Event);
}).call(this);

