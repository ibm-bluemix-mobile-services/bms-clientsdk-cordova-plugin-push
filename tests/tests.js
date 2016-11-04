exports.defineAutoTests = function() {
	describe('BMSPush test suite', function () {

		var fail = function (done, context, message) {
            if (context) {
                if (context.done) return;
                context.done = true;
            }

            if (message) {
                expect(false).toBe(true, message);
            } else {
                expect(false).toBe(true);
            }
            setTimeout(function () {
                done();
            });
    	};
        var succeed = function (done, context) {
            if (context) {
                if (context.done) return;
                context.done = true;
            }

            expect(true).toBe(true);

            setTimeout(function () {
                done();
            });
        };

		describe('BMSPush API', function() {

			it('BMSPush should exist', function(){
				expect(BMSPush).toBeDefined();
			});

            it('BMSPush.initialize() should exist and is a function', function(){
                expect(typeof BMSPush.initialize).toBeDefined();
                expect(typeof BMSPush.initialize == 'function').toBe(true);
            });

			it('BMSPush.retrieveSubscriptions() should exist and is a function', function(){
				expect(typeof BMSPush.retrieveSubscriptions).toBeDefined();
				expect(typeof BMSPush.retrieveSubscriptions == 'function').toBe(true);
			});

            it('BMSPush.retrieveAvailableTags() should exist and is a function', function(){
                expect(typeof BMSPush.retrieveAvailableTags).toBeDefined();
                expect(typeof BMSPush.retrieveAvailableTags == 'function').toBe(true);
            });

            it('BMSPush.subscribe() should exist and is a function', function(){
                expect(typeof BMSPush.subscribe).toBeDefined();
                expect(typeof BMSPush.subscribe == 'function').toBe(true);
            });

            it('BMSPush.unsubscribe() should exist and is a function', function(){
                expect(typeof BMSPush.unsubscribe).toBeDefined();
                expect(typeof BMSPush.unsubscribe == 'function').toBe(true);
            });

            it('BMSPush.registerDevice() should exist and is a function', function(){
                expect(typeof BMSPush.registerDevice).toBeDefined();
                expect(typeof BMSPush.registerDevice == 'function').toBe(true);
            });

            it('BMSPush.unregisterDevice() should exist and is a function', function(){
                expect(typeof BMSPush.unregisterDevice).toBeDefined();
                expect(typeof BMSPush.unregisterDevice == 'function').toBe(true);
            });

            it('BMSPush.registerNotificationsCallback() should exist and is a function', function(){
                expect(typeof BMSPush.registerNotificationsCallback).toBeDefined();
                expect(typeof BMSPush.registerNotificationsCallback == 'function').toBe(true);
            });

		});

        describe('BMSPush instance', function() {
            var execSpy;
            beforeEach(function() {
                execSpy = spyOn(cordova, "exec");
            });

            it('should call initialize and call the success callback', function(done) {
                BMSPush.initialize();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call registerDevice and call the success callback', function(done) {
                BMSPush.registerDevice();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call unregisterDevice and call the success callback', function(done) {
                BMSPush.unregisterDevice();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call subscribe and call the success callback', function(done) {
                BMSPush.subscribe();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call unsubscribe and call the success callback', function(done) {
                BMSPush.unsubscribe();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call retrieveAvailableTags and call the success callback', function(done) {
                BMSPush.retrieveAvailableTags();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call retrieveSubscriptions and call the success callback', function(done) {
                BMSPush.retrieveSubscriptions();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

        });

	});
};