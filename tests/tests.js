exports.defineAutoTests = function() {
	describe('MFPPush test suite', function () {

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

		describe('MFPPush API', function() {

			it('MFPPush should exist', function(){
				expect(MFPPush).toBeDefined();
			});

			it('MFPPush.retrieveSubscriptions() should exist and is a function', function(){
				expect(typeof MFPPush.retrieveSubscriptions).toBeDefined();
				expect(typeof MFPPush.retrieveSubscriptions == 'function').toBe(true);
			});

            it('MFPPush.retrieveAvailableTags() should exist and is a function', function(){
                expect(typeof MFPPush.retrieveAvailableTags).toBeDefined();
                expect(typeof MFPPush.retrieveAvailableTags == 'function').toBe(true);
            });

            it('MFPPush.subscribe() should exist and is a function', function(){
                expect(typeof MFPPush.subscribe).toBeDefined();
                expect(typeof MFPPush.subscribe == 'function').toBe(true);
            });

            it('MFPPush.unsubscribe() should exist and is a function', function(){
                expect(typeof MFPPush.unsubscribe).toBeDefined();
                expect(typeof MFPPush.unsubscribe == 'function').toBe(true);
            });

            it('MFPPush.registerDevice() should exist and is a function', function(){
                expect(typeof MFPPush.registerDevice).toBeDefined();
                expect(typeof MFPPush.registerDevice == 'function').toBe(true);
            });

            it('MFPPush.unregisterDevice() should exist and is a function', function(){
                expect(typeof MFPPush.unregisterDevice).toBeDefined();
                expect(typeof MFPPush.unregisterDevice == 'function').toBe(true);
            });

            it('MFPPush.registerNotificationsCallback() should exist and is a function', function(){
                expect(typeof MFPPush.registerNotificationsCallback).toBeDefined();
                expect(typeof MFPPush.registerNotificationsCallback == 'function').toBe(true);
            });

		});

        describe('MFPPush instance', function() {
            var execSpy;
            beforeEach(function() {
                execSpy = spyOn(cordova, "exec");
            });

            it('should call registerDevice and call the success callback', function(done) {
                MFPPush.registerDevice();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call unregisterDevice and call the success callback', function(done) {
                MFPPush.unregisterDevice();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call subscribe and call the success callback', function(done) {
                MFPPush.subscribe();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call unsubscribe and call the success callback', function(done) {
                MFPPush.unsubscribe();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call retrieveAvailableTags and call the success callback', function(done) {
                MFPPush.retrieveAvailableTags();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

            it('should call retrieveSubscriptions and call the success callback', function(done) {
                MFPPush.retrieveSubscriptions();
                setTimeout(function() {
                    expect(execSpy).toHaveBeenCalled();
                    done();
                }, 100);
            });

        });

	});
};