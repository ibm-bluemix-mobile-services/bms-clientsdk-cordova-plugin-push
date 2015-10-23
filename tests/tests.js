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

            it('MFPPush.subscribe() should exist and is a function', function(){
                expect(typeof MFPPush.subscribe).toBeDefined();
                expect(typeof MFPPush.subscribe == 'function').toBe(true);
            });

            it('MFPPush.unsubscribe() should exist and is a function', function(){
                expect(typeof MFPPush.unsubscribe).toBeDefined();
                expect(typeof MFPPush.unsubscribe == 'function').toBe(true);
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
	});
};