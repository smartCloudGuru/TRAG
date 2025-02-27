/**
 *  @who:   Samuel Arroyo (CloudSocius)
 *  @what:  REST service for sending emails
 *  @when:  26-03-2015
 */
@RestResource(urlMapping='/sendPDFEmail/*')
global class AppraisalEmailREST{
    @HttpPost
    global static void sendEmail(Id appId) {

    	//AppraisalEmailSender.sendAppraisalInformation(appId);

    }
}