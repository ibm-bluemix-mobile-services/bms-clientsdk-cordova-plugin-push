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

		});
	});
};