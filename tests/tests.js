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

			it('MFPPush.getSubscriptionStatus() should exist and is a function', function(){
				expect(typeof MFPPush.getSubscriptionStatus).toBeDefined();
				expect(typeof MFPPush.getSubscriptionStatus == 'function').toBe(true);
			});

            it('MFPPush.retrieveAvailableTags() should exist and is a function', function(){
                expect(typeof MFPPush.retrieveAvailableTags).toBeDefined();
                expect(typeof MFPPush.retrieveAvailableTags == 'function').toBe(true);
            });

            it('MFPPush.subscribeToTags() should exist and is a function', function(){
                expect(typeof MFPPush.subscribeToTags).toBeDefined();
                expect(typeof MFPPush.subscribeToTags == 'function').toBe(true);
            });

            it('MFPPush.unsubscribe() should exist and is a function', function(){
                expect(typeof MFPPush.unsubscribeFromTags).toBeDefined();
                expect(typeof MFPPush.unsubscribeFromTags == 'function').toBe(true);
            });

            it('MFPPush.register() should exist and is a function', function(){
                expect(typeof MFPPush.register).toBeDefined();
                expect(typeof MFPPush.register == 'function').toBe(true);
            });

            it('MFPPush.unregister() should exist and is a function', function(){
                expect(typeof MFPPush.unregister).toBeDefined();
                expect(typeof MFPPush.unregister == 'function').toBe(true);
            });

            it('MFPPush.registerIncomingNotificationListener() should exist and is a function', function(){
                expect(typeof MFPPush.registerIncomingNotificationListener).not.toBeDefined();
                expect(typeof MFPPush.registerIncomingNotificationListener == 'function').not.toBe(true);
            });

		});

        describe('MFPPush instance', function() {

            it('should call register and call the success callback', function(done) {
                spyOn(MFPPush, 'register').and.callFake(
                    function() {
                        cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPPush", "register");
                });
            });

            it('should call unregister and call the success callback', function(done) {
                spyOn(MFPPush, 'unregister').and.callFake(
                    function() {
                        cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPPush", "unregister");
                    });
            });

            it('should call retrieveAvailableTags and call the success callback', function(done) {
                spyOn(MFPPush, 'retrieveAvailableTags').and.callFake(
                    function() {
                        cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPPush", "retrieveAvailableTags");
                    });
            });

            it('should call getSubscriptionStatus and call the success callback', function(done) {
                spyOn(MFPPush, 'getSubscriptionStatus').and.callFake(
                    function() {
                        cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPPush", "getSubscriptionStatus");
                    });
            });

        });

	});
};