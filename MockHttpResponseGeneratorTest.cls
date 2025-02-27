@isTest
global class MockHttpResponseGeneratorTest implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {


        System.assertEquals(Label.WLSearchEndpoint+'name?content-set=WL&record-type=P&search-type=broad&name=David%20Cameron', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        //res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}