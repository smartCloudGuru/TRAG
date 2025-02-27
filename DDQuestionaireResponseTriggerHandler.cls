/************************************************************************************************************************                                                                                         
 
              ***                                                            ***          *****                          
            ****                                                            *****       *****                            
          ****                                                                         *****                             
    ****************         **********         ****       *****        *****       *****             ************      
       ****             *****                *****       *****       *****       ******         *******                
      ***            ****       ****       *****       *****        ****        *****        ******      *****         
    ****           *****       ****       *****       *****       *****       *****        *****        ****           
   ****       ********       ****     *******       *****      ******       ******      *******       *****      ***** 
  *************** ***** *********  **********************************************************************************   
   ********          *****************     *******      ******     ********     *******       *******    *******         
                           ******                                                                                        
                         ******                                                                                          
                        ****                                                                          
                       ***                                                                         SOCIAL | MOBILE | WEB  
  
 
  
Crafted by    : Mayank Sharma
               : msharma@tquila.com 
               : www.tquila.com

 Code purpose  : a. Creates a PDF contaning Questions and Answers related to the Questionnaire Response
                 b. Attach the PDF to the questionnare related documents


 Birthday      : 07/11/2014
 Api version   : v32

 ****************************************************************************************************************************/

public class DDQuestionaireResponseTriggerHandler{
    
	String styleSheet='<style>/*! normalize v3.0.2 | MIT License | git.io/normalize */html,input[type=search]{box-sizing:border-box}h2 a,h3 a,p a{text-decoration:none}a,blockquote,body,h1,h2,h3,h4,h5,h6{color:#424242}#site-logo,img{max-width:100%}a:focus,a:hover,address a,address a:focus,address a:hover,address p a,address p a:focus,address p a:hover,hr,p a{color:#f5fafc}html{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}body{margin:0}article,aside,details,figcaption,figure,footer,header,hgroup,main,menu,nav,section,summary{display:block}audio,canvas,progress,video{display:inline-block;vertical-align:baseline}audio:not([controls]){display:none;height:0}[hidden],template{display:none}a:active,a:hover{outline:0}abbr[title]{border-bottom:1px dotted}b,optgroup,strong{font-weight:700}dfn{font-style:italic}h1{margin:.67em 0}mark{background:#ff0;color:#000}small{font-size:80%}sub,sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline}sup{top:-.5em}sub{bottom:-.25em}svg:not(:root){overflow:hidden}figure{margin:1em 40px}pre,textarea{overflow:auto}code,kbd,pre,samp{font-family:monospace,monospace;font-size:1em}button,input,optgroup,select,textarea{color:inherit;font:inherit;margin:0}blockquote,html{font-family:"Open Sans",sans-serif}button{overflow:visible}button,select{text-transform:none}button,html input[type=button],input[type=reset],input[type=submit]{-webkit-appearance:button;cursor:pointer}button[disabled],html input[disabled]{cursor:default}button::-moz-focus-inner,input::-moz-focus-inner{border:0;padding:0}input{line-height:normal}input[type=checkbox],input[type=radio]{box-sizing:border-box;padding:0}input[type=number]::-webkit-inner-spin-button,input[type=number]::-webkit-outer-spin-button{height:auto}input[type=search]{-webkit-appearance:textfield;box-sizing:content-box}input[type=search]::-webkit-search-cancel-button,input[type=search]::-webkit-search-decoration{-webkit-appearance:none}legend{border:0;padding:0}td,th{padding:0}*,:after,:before{box-sizing:inherit;outline:0;-webkit-tap-highlight-color:transparent!important;tap-highlight-color:transparent!important;-webkit-backface-visibility:hidden!important;backface-visibility:hidden!important}table,table *{-webkit-backface-visibility:visible!important;backface-visibility:visible!important}.clearfix:after,.gform_fields:after,.main-wrapper:after,.pakery-grid:after{visibility:hidden;display:block;font-size:0;content:" ";clear:both;height:0}* html .clearfix{height:1%}.clearfix,.gform_fields,.main-wrapper,.pakery-grid{display:block}.visually-hidden{border:0;clip:rect(0 0 0 0);height:1px;margin:-1px;overflow:hidden;padding:0;position:absolute;width:1px}html,html#BTT{margin-top:0!important}blockquote p,blockquote strong,p strong{margin-bottom:0}blockquote,body{position:relative}blockquote:after,blockquote:before{content:"";position:absolute;width:53.2px;height:40.84px;background-repeat:no-repeat}.img-replacement{display:inline-block;text-indent:200%;white-space:nowrap;overflow:hidden}.hide{display:none}#site-logo,#site-logo img,.show,a img.aligncenter,blockquote:after,img,img.aligncenter{display:block}.list-no-bullets{list-style:none}html{font-size:62.5%;font-weight:300}#wpadminbar{display:none}body{background-color:#fff;font-size:10px;font-size:1rem}address,blockquote,h1,h2,h3,h4,h5,h6,p,pre,table{color:#424242;margin-top:0;margin-bottom:8px;font-weight:300;line-height:1.4em}h1,h2{color:#193862}blockquote strong,h1,h2,h3,p strong{font-weight:700}@media (max-width:750px){body{font-size:10px;font-size:1rem}address,blockquote,h1,h2,h3,h4,h5,h6,p,pre,table{margin-bottom:15px}}h1{font-size:24px;font-size:2.4rem}@media (max-width:650px){h1{font-size:15px;font-size:1.5rem}}h2{font-size:16px;font-size:1.6rem}@media (max-width:750px){h2{font-size:14px;font-size:1.4rem}}h2 a{font-size:16px;font-size:1.6rem}@media (max-width:750px){h2 a{font-size:14px;font-size:1.4rem}}h3{font-size:12px;font-size:1.2rem}@media (max-width:750px){h3{font-size:12px;font-size:1.2rem}}h3 a{font-size:12px;font-size:1.2rem}@media (max-width:750px){h3 a{font-size:12px;font-size:1.2rem}}h4{font-size:12px;font-size:1.2rem}@media (max-width:750px){h4{font-size:12px;font-size:1.2rem}}h5{font-size:11px;font-size:1.1rem}@media (max-width:750px){h5{font-size:11px;font-size:1.1rem}}h6{font-size:10px;font-size:1rem}@media (max-width:750px){h6{font-size:14px;font-size:1.4rem}}p{font-size:10px;font-size:1rem;line-height:1.6em;margin-bottom:10px}@media (max-width:750px){p{font-size:8px;font-size:.8rem}}p a{font-size:10px;font-size:1rem}@media (max-width:750px){p a{font-size:8px;font-size:.8rem}}p a:focus,p a:hover{text-decoration:underline}p strong{line-height:1.7em}blockquote{font-size:10px;font-size:1rem;margin:85px auto 16px;font-style:italic;line-height:1.35em}blockquote:before{display:block;top:-21px;left:-14px;background-image:url(../images/quote-open.svg)}.lt-ie9 blockquote:before,.no-svg blockquote:before{background-image:url(../images/quote-open.png)}blockquote:after{bottom:-12px;right:-14px;background-image:url(../images/quote-close.svg)}.lt-ie9 blockquote:after,.no-svg blockquote:after{background-image:url(../images/quote-close.png)}@media (max-width:750px){blockquote{font-size:24px;font-size:2.4rem;margin:40px auto 16px}blockquote:before{top:-13px;left:0;width:35px;height:27px;background-size:35px}blockquote:after{bottom:-13px;right:0;width:35px;height:27px;background-size:35px}}blockquote p{font-size:10px;font-size:1rem;line-height:1.3em}a{background-color:transparent;font-size:16px;font-size:1.6rem;-webkit-transition:all .25s ease-in-out;transition:all .25s ease-in-out;cursor:pointer}dl,ol,ul{margin:0 0 30px;padding-left:0;list-style-position:inside;font-size:0}dl dd,dl dt,dl li,ol dd,ol dt,ol li,ul dd,ul dt,ul li{font-size:10px;font-size:1rem;margin-left:0;line-height:1.6em;margin-bottom:8px}dl dd>a,dl dt>a,dl li>a,ol dd>a,ol dt>a,ol li>a,ul dd>a,ul dt>a,ul li>a{font-size:10px;font-size:1rem;color:#f5fafc;text-decoration:none}dl dd>a:focus,dl dd>a:hover,dl dt>a:focus,dl dt>a:hover,dl li>a:focus,dl li>a:hover,ol dd>a:focus,ol dd>a:hover,ol dt>a:focus,ol dt>a:hover,ol li>a:focus,ol li>a:hover,ul dd>a:focus,ul dd>a:hover,ul dt>a:focus,ul dt>a:hover,ul li>a:focus,ul li>a:hover{text-decoration:underline}dl dd,ol dd,ul dd{margin-bottom:20px}address,address p{font-size:10px;font-size:1rem;font-style:normal;line-height:1.45em;margin-bottom:8px}address p,address p p{margin-bottom:0}address a,address p a{text-decoration:none}img{border:0;width:auto;height:auto}img.alignright{float:right;margin:0 0 1em 1em}img.alignleft{float:left;margin:0 1em 1em 0}img.aligncenter{clear:both;margin-left:auto;margin-right:auto}a img.alignright{float:right;margin:0 0 1em 1em}a img.alignleft{float:left;margin:0 1em 1em 0}.fieldset,header h1{margin-bottom:0}a img.aligncenter{clear:both;margin-left:auto;margin-right:auto}.menu-bottom-outer,.menu-top-outer{margin:0;width:100%}::selection{background:#193862;color:#fff}::-moz-selection{background:#193862;color:#fff}.full-bg,.icon{background-repeat:no-repeat}.fieldset .field{position:relative;padding-bottom:1px}.fieldset div.mage-error[generated]{position:absolute;bottom:5px}.relative,header{position:relative}header{z-index:99;width:100%;-webkit-transition:background-color .75s 0s,top .25s 0s;transition:background-color .75s 0s,top .25s 0s;-webkit-transform:translateZ(0);transform:translateZ(0);-webkit-perspective:999999px;perspective:999999px}.no-top header{background-color:transparent}hr,table tbody{background-color:#f5fafc}header h1{float:left;padding-top:42px;padding-left:20px;padding-bottom:5px}#site-logo{margin:0;height:auto;width:179.67px;float:right;padding-top:36px;padding-bottom:0}@media (max-width:650px){header h1{padding-top:18px;padding-left:10px}#site-logo{padding-top:10px;padding-left:0;width:110px}}#site-logo img{width:100%;height:auto;margin-left:0}.menu-top-outer .wrapper{padding-top:0;padding-bottom:0;max-width:820px}@media (max-width:750px){.menu-top-outer .wrapper{padding-top:1px}.mob-only{display:none}}.menu-bottom-outer{padding-bottom:7px}.menu-bottom-outer .wrapper{padding-top:0;padding-bottom:0;max-width:820px}.mob-only{display:none}.block,footer .copy{display:block}.submitted{padding-left:20px}@media (max-width:650px){.submitted{padding-left:10px}}.submitted .by,.submitted .on{float:left;clear:left;font-weight:700}.submitted .info{float:left;padding-left:15px}.submitted .by,.submitted .info,.submitted .on{font-size:12px;font-size:1.2rem;margin-top:-5px;margin-bottom:8px}@media (max-width:750px){.submitted .info{padding-left:5px}.submitted .by,.submitted .info,.submitted .on{font-size:10px;font-size:1rem}}.footer-outer-wrapper{background-size:cover;background-position:50% 0}footer .footer-top-outer .wrapper{padding-top:14px;padding-bottom:14px}footer .copy{font-size:8.5px;font-size:.85rem;padding-left:19px;padding-right:19px}.title,hr{font-size:0}.col1.full,.col10.full,.col11.full,.col12.full,.col2.full,.col3.full,.col4.full,.col5.full,.col6.full,.col7.full,.col8.full,.col9.full{margin:0}.col1.full.matchHeight,.col10.full.matchHeight,.col11.full.matchHeight,.col12.full.matchHeight,.col2.full.matchHeight,.col3.full.matchHeight,.col4.full.matchHeight,.col5.full.matchHeight,.col6.full.matchHeight,.col7.full.matchHeight,.col8.full.matchHeight,.col9.full.matchHeight{margin-bottom:0}.col1.full{width:8.33333%}.col2.full{width:16.66667%}.col3.full.full{width:25%}@media (max-width:900px){.col3.full.full{width:50%}}@media (max-width:600px){.col3.full.full{width:100%}}.col4.full{width:33.33333%}.col5.full{width:41.66667%}.col6.full{width:50%}.col7.full{width:58.33333%}.col8.full{width:66.66667%}.col9.full{width:75%}.col10.full{width:83.33333%}.col11.full{width:91.66667%}.col12.full{width:100%}@media (max-width:800px){.col4.full{width:100%;float:none}}.col1,.col10,.col11,.col2,.col3,.col4,.col5,.col6,.col7,.col8,.col9{margin-left:2.43902%;margin-bottom:20px}.col1.first,.col2.first,.col3.first,.col4.first{margin-left:0;clear:left}.col1.matchHeight,.col10.matchHeight,.col11.matchHeight,.col2.matchHeight,.col3.matchHeight,.col4.matchHeight,.col5.matchHeight,.col6.matchHeight,.col7.matchHeight,.col8.matchHeight,.col9.matchHeight{margin-bottom:20px}.col1{width:6.09756%;float:left}.lt-ie8 .col1{width:5.79756%}.col1.last{float:right}.col2{width:14.63415%;float:left}.lt-ie8 .col2{width:14.33415%}.col2.last{float:right}.col3{width:23.17073%;float:left}.lt-ie8 .col3{width:22.87073%}.col3.last{float:right}@media (max-width:850px){.col3,.col3.first,.col3.last{width:48.78049%}.col3:nth-of-type(2n+1){float:left;clear:left;margin-left:0}}@media (max-width:500px){.col3,.col3.first,.col3.last,.col3:nth-of-type(2n+1),.col3:nth-of-type(2n+2){margin-left:0;width:100%;float:none}}.col4{width:31.70732%;float:left}.lt-ie8 .col4{width:31.40732%}.col4.last{float:right}@media (max-width:800px){.col4,.col4.first,.col4.last{width:48.78049%}.col4:nth-of-type(2n+2){float:right;clear:none}.col4:nth-of-type(2n+1){margin-left:0;float:left;clear:left}}.col5.first,.col6.first{margin-left:0;clear:left}@media (max-width:550px){.col4,.col4.first,.col4:nth-of-type(2n+1),.col4:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col5{width:40.2439%;float:left}.lt-ie8 .col5{width:39.9439%}.col5.last{float:right}@media (max-width:650px){footer .copy{padding-left:10px;padding-right:10px}.col5,.col5.first,.col5.last{width:48.78049%;margin-top:0}.col5,.col5.first,.col5:nth-of-type(2n+1),.col5:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col6{width:48.78049%;float:left}.lt-ie8 .col6{width:48.48049%}.col6.last{float:right}@media (max-width:800px){.col6 .col6,.col6 .col6.first,.col6 .col6:nth-of-type(2n+1),.col6 .col6:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}@media (max-width:450px){.col6,.col6.first,.col6:nth-of-type(2n+1),.col6:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}@media (max-width:450px) and (max-width:450px){.col6 .col6{width:48.78049%;float:left}.lt-ie8 .col6 .col6{width:48.48049%}.col6 .col6.first{width:48.78049%;margin-left:0;clear:left;float:left}.lt-ie8 .col6 .col6.first{width:48.48049%}.col6 .col6.last{width:48.78049%;float:right;clear:none}.lt-ie8 .col6 .col6.last{width:48.48049%}}.col10.first,.col11.first,.col7.first,.col8.first,.col9.first{margin-left:0;clear:left}@media (max-width:450px) and (max-width:420px){.col6 .col6,.col6 .col6.first,.col6 .col6:nth-of-type(2n+1),.col6 .col6:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col7{width:57.31707%;float:left}.lt-ie8 .col7{width:57.01707%}.col7.last{float:right}@media (max-width:650px){.col7,.col7+.col5,.col7.first,.col7:nth-of-type(2n+1),.col7:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col8{width:65.85366%;float:left}.lt-ie8 .col8{width:65.55366%}.col8.last{float:right}@media (max-width:800px){.col8,.col8.first,.col8:nth-of-type(2n+1),.col8:nth-of-type(2n+2){width:100%;margin-left:0;float:none}.col8+.col4{width:100%}}.col9{width:74.39024%;float:left}.lt-ie8 .col9{width:74.09024%}.col9.last{float:right}@media (max-width:930px){.col9,.col9.first,.col9:nth-of-type(2n+1),.col9:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col10{width:82.92683%;float:left}.lt-ie8 .col10{width:82.62683%}.col10.last{float:right}@media (max-width:950px){.col10,.col10.first,.col10:nth-of-type(2n+1),.col10:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col11{width:91.46341%;float:left}.lt-ie8 .col11{width:91.16341%}.col11.last{float:right}@media (max-width:950px){.col11,.col11.first,.col11:nth-of-type(2n+1),.col11:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.col12{width:100%;float:left;clear:both;margin:0 0 20px}.col12.align-center img,.page-wrapper{margin:0 auto}.col3.alt,.col4.alt{margin-left:4.87805%}.col3.alt{margin-bottom:40px}.col3.alt.alt-bottom,.col3.alt.alt-bottom.matchHeight,.col3.alt.matchHeight{margin-bottom:20px}.col4.alt{margin-bottom:40px;width:30.0813%;float:left}.col4.alt.alt-bottom,.col4.alt.alt-bottom.matchHeight,.col4.alt.matchHeight{margin-bottom:20px}.lt-ie8 .col4.alt{width:29.7813%}.col4.alt.first{margin-left:0;clear:left}.col4.alt.last{float:right}@media (max-width:800px){.col4.alt{width:48.78049%}.col4.alt.first,.col4.alt.last{width:47.56098%}.col4.alt:nth-of-type(2n+2){float:right;clear:none}.col4.alt:nth-of-type(2n+1){margin-left:0;float:left;clear:left}}@media (max-width:550px){.col4.alt,.col4.alt.first,.col4.alt:nth-of-type(2n+1),.col4.alt:nth-of-type(2n+2){width:100%;margin-left:0;float:none}}.align-left{text-align:left}.align-center{text-align:center}.align-right{text-align:right}.web-link{font-style:italic;word-wrap:break-word}.clear-left{clear:left}.clear-both{clear:both}.clear-right{clear:right}.left{float:left}.none{float:none}.right{float:right}.line-bottom{border-bottom:1px solid #fff;padding-bottom:20px;margin-bottom:30px}.padding-top{padding-top:20px}.first.margin-top,.margin-top{margin-top:20px}.margin-top-small{margin-top:10px}.margin-none{margin:0!important}.padding-none{padding:0!important}.auto.auto{width:auto;max-width:100%}.main-wrapper{padding-top:0;padding-bottom:0;width:100%;min-height:calc(100vh - 160px - 570px)}.page-wrapper{padding:0;width:100%;position:relative;-webkit-transition:.25s;transition:.25s;height:auto;min-height:0}.wrapper,.wrapper-inner,.wrapper-outer{margin:0 auto;width:96%;padding-bottom:1px;position:relative}.wrapper{max-width:820px;clear:both}.wrapper-inner,.wrapper-outer{padding-top:1px}hr,table{width:100%}.wrapper-outer{width:100%;padding-top:0;padding-bottom:0}.wrapper-inner{max-width:567px}hr{box-sizing:content-box;height:21px;border:0;position:relative;margin:0 auto 73px}.title{padding:30px 31px 23px;position:relative;text-align:center;border-bottom:1px solid #dadada}@media (max-width:650px){.wrapper-inner.mob-wide,.wrapper-outer.mob-wide,.wrapper.mob-wide{width:100%}.title{padding:27px 5px 28px}}.title *{margin-bottom:0}.full-bg{background-position:center center;background-size:cover;position:relative}.container{border:1px solid #193862;border-radius:9px;padding:12px 19px 2px;margin-bottom:20px}.container:last-of-type,fieldset h3,table tbody p:last-of-type{margin-bottom:0}@media (max-width:650px){.container{padding:12px 9px 2px}}table,table td,table th,table tr{border:none;border-collapse:collapse;padding:0;max-width:100%;font-size:10px;font-size:1rem;text-align:left;line-height:1.4em;min-height:20px;vertical-align:top}@media (max-width:750px){table,table td,table th,table tr{font-size:10px;font-size:1rem}}table{border-spacing:0;margin-bottom:18px}@media (max-width:650px){table{margin-bottom:7px}}table tbody td,table tbody th,table tbody tr{border:1px solid #b7bcbf}fieldset,table tbody tr{border:none}table tbody th{width:28.3%;padding:6px 9px;text-align:right}@media (max-width:600px){table tbody th{width:36.7%}}.col6 table tbody th{width:36.7%}table tbody th:empty{border-top:none;border-bottom:none}table tbody td{padding:6px 7px 6px 14px}table thead{background-color:#424242}table thead td,table thead th{border:1px solid #b7bcbf;border-top:none;padding:6px 1px 6px 14px}table thead td{border-right:1px solid #424242}table thead th{border-left:1px solid #424242}table thead *{color:#fff}fieldset{padding:0;margin:0!important}fieldset h3{background-color:#193862;color:#fff;padding:6px 10px;border-bottom:.5px solid #424242}.icon{background-image:url(../images/file.svg);width:12px;height:15px;display:inline-block;zoom:1;margin-bottom:-4px;margin-right:4px}.lt-ie9 .icon,.no-svg .icon{background-image:url(../images/file.png)} </style>';
 //String styleSheet= '';
    /**
        On before update of Questionnaire Response
        This method Creates a PDF contaning Questions and Answers related to the Questionnaire Response
        and attach the PDF to the questionnare related documents
    */
    public void beforeUpdate(list<dd_Questionnaire_Response__c> qrList, Map<Id, dd_Questionnaire_Response__c > newMap, Map<Id, dd_Questionnaire_Response__c> oldMap){
        
        system.debug('DDQuestionaireResponseTriggerHandler :: beforeUpdate :: start');
        List<Attachment> attachList = new List<Attachment>();
        List<Id> qrIdList = new List<Id>();
        Map<Id, Id> qrId_csId_Map = new Map<Id, Id>(); 
        Map<Id, Case> csId_cs_Map = new Map<Id, Case>(); 
		Map<String, String> sectionNumberQuestionAnswerMap;
        Map<String, Map<String, String>> sectionName_SectionNumberQuestionAnswerMap = new Map<String, Map<String, String>>();
        String sectionName = '';
        String confInfo = 'This information is strictly private and confidential &copy; 2017 ';        
        system.debug('qrList :: '+qrList);
        for(dd_Questionnaire_Response__c qrVal : qrList){
            if((newMap.get(qrVal.Id).QSection1Flagged__c != oldMap.get(qrVal.Id).QSection1Flagged__c)
               || newMap.get(qrVal.Id).QSection2Flagged__c != oldMap.get(qrVal.Id).QSection2Flagged__c
               || newMap.get(qrVal.Id).QSection3Flagged__c != oldMap.get(qrVal.Id).QSection3Flagged__c
               || newMap.get(qrVal.Id).QSection4Flagged__c != oldMap.get(qrVal.Id).QSection4Flagged__c
               || newMap.get(qrVal.Id).QSection5Flagged__c != oldMap.get(qrVal.Id).QSection5Flagged__c
               || newMap.get(qrVal.Id).QSection6Flagged__c != oldMap.get(qrVal.Id).QSection6Flagged__c
               || newMap.get(qrVal.Id).QSection7Flagged__c != oldMap.get(qrVal.Id).QSection7Flagged__c){
                   qrId_csId_Map.put(qrVal.Id, qrVal.dd_Assessment__c);
               }
            if((newMap.get(qrVal.Id).dd_Status__c == 'Submitted' && oldMap.get(qrVal.Id).dd_Status__c == 'Sent')
               || (newMap.get(qrVal.Id).dd_Status__c == 'Submitted' && oldMap.get(qrVal.Id).dd_Status__c == 'Partial Save in FA')){
                   qrIdList.add(qrVal.Id);
               }                       
        }
        
        List<Case> csList_DB = [select Id, AccountId, Account.parentId, QSection1Flagged__c, QSection2Flagged__c, QSection3Flagged__c, QSection4Flagged__c, QSection5Flagged__c, QSection6Flagged__c, 
                               QSection7Flagged__c from Case where id in: qrId_csId_Map.values()];
        system.debug('csList_DB :: '+csList_DB);
        //system.debug('csList_DB.get(0).Account.parentId :: '+csList_DB.get(0).Account.parentId);
        for(Case csVal_DB : csList_DB){
            if(String.valueOf(csVal_DB.Account.parentId).contains(Label.WLSanofiaccountId)){
                csId_cs_Map.put(csVal_DB.Id, csVal_DB);
            }
        }
        system.debug('csId_cs_Map :: '+csId_cs_Map);
        if(csId_cs_Map.size() > 0){
            for(Id qrId_csId_Val : qrId_csId_Map.keySet()){
                system.debug('newMap.get(qrId_csId_Val).QSection1Flagged__c :: '+newMap.get(qrId_csId_Val).QSection1Flagged__c);
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection1Flagged__c = newMap.get(qrId_csId_Val).QSection1Flagged__c;
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection2Flagged__c = newMap.get(qrId_csId_Val).QSection2Flagged__c;
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection3Flagged__c = newMap.get(qrId_csId_Val).QSection3Flagged__c;
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection4Flagged__c = newMap.get(qrId_csId_Val).QSection4Flagged__c;
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection5Flagged__c = newMap.get(qrId_csId_Val).QSection5Flagged__c;
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection6Flagged__c = newMap.get(qrId_csId_Val).QSection6Flagged__c;
                csId_cs_Map.get(qrId_csId_Map.get(qrId_csId_Val)).QSection7Flagged__c = newMap.get(qrId_csId_Val).QSection7Flagged__c;
            }
        }
        List<dd_Questionnaire_Response__c> queriedQRList = [Select Id, Name, OwnerId, dd_Counterparty__c, DD_Submitted_Time__c, 
                                                                dd_Assessment__r.Id, dd_Assessment__r.ContactId, 
                                                            dd_Assessment__r.Contact.Account.Parent.name,
                                                            dd_Assessment__r.Contact.Account.Parent.Verification_by_Client_Only__c,
                                                                dd_Questionnaire_Name__c, LastModifiedDate, dd_Assessment__r.Contact.Email,  
                                                                (Select dd_Question__c, dd_Answer__c, dd_Question_Number__c, dd_Section_Number__c,
                                                                 Multiple_answers__c, dd_Section_Name__c 
                                                                From Questions__r 
                                                                order by dd_Section_Number__c,dd_Question_Number__c asc) 
                                                                From dd_Questionnaire_Response__c d where Id in: qrIdList];
                
        system.debug('queriedQRList :: '+queriedQRList);
        for(dd_Questionnaire_Response__c queriedQRVal : queriedQRList){
            system.debug('queriedQRVal :: '+queriedQRVal); 
            Attachment attach = new Attachment();
            Blob body;
            String formHtmlStart = '<HTML><head><meta charset="utf-8></meta><meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>'+
                '<title>The Risk Advisory Group</title><meta name="description" content=""></meta>'+
                '<meta name="viewport" content="width=device-width, initial-scale=1"></meta>'+
                '<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,700" rel="stylesheet">'+
                styleSheet+'</head><BODY><header id="BTT" role="banner">'+
                '<div class="menu-top-outer clearfix"><div class="wrapper clearfix"><a href="" id="site-logo">'+
				'<img src="https://c.na60.content.force.com/servlet/servlet.FileDownload?file=015a0000002mjwv" srcSET="https://c.na60.content.force.com/servlet/servlet.FileDownload?file=015a0000002mjwv"/></a>';
            String formHtmlEnd = '<footer role="contentinfo" class="footer-outer-wrapper clearfix"><div class="footer-top-outer clearfix">'+
                '<section class="wrapper clearfix"><span class="copy">'+confInfo+queriedQRVal.dd_Assessment__r.Contact.Account.Parent.name +'</span>'+
                '</section></div></footer><script src="https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>'+
                '<script src="assets/js/modernizr.min.js"></script></BODY></HTML>';
            String pdfContent;
            
            //String replaceQAnswer;                        
            if(queriedQRVal.dd_Assessment__r.Contact.Account.Parent.Verification_by_Client_Only__c){
                newMap.get(queriedQRVal.Id).dd_Status__c = 'Completed by RAG';
                newMap.get(queriedQRVal.Id).Assigned_to_User__c = false;
            }            
            try {
                pdfContent = ''+formHtmlStart ;
                pdfContent = pdfContent + '<h1>'+queriedQRVal.Name+'</h1></div></div>'+
                    '<div class="menu-bottom-outer clearfix"><div class="wrapper clearfix"><span class="submitted clearfix"><span class="by">Submitted by: </span><span class="info">';
                pdfContent = pdfContent + queriedQRVal.dd_Counterparty__c+'</span>'+
                    '<span class="on">Submitted on: </span><span class="info">';
                pdfContent = pdfContent + queriedQRVal.LastModifiedDate+'</span></span></div></div></header>';
                //pdfContent = pdfContent + '<p><H3 style="text-align: center; text-decoration: underline;">Questionnaire Responses </H3></p>';
                pdfContent = pdfContent + '<div class="page-wrapper clearfix"><main class="main-wrapper clearfix matchHeight">'+
                    '<section class="wrapper clearfix container">';
                pdfContent = pdfContent + '<table><tbody>';
                //List<dd_Questions__c> qList = [select Id from dd_Questions__c where dd_Questionnaire_Response__c =: queriedQRVal.Id];
                for(dd_Questions__c questionVal : queriedQRVal.Questions__r) {                    
                    Boolean isMultipleAnswerSection = false;   
                    List<String> replaceQAnswer = new List<String>();
                    String replaceQAnswerValFinal = '';
                    system.debug('questionVal.dd_Answer__c :: '+questionVal.dd_Answer__c);
                    /*if(questionVal.Multiple_answers__c == 'Yes' && !String.isEmpty(questionVal.dd_Answer__c) 
                       && questionVal.dd_Answer__c.split(',').size() > 0){
                        if(!sectionName.equalsIgnoreCase(questionVal.dd_Section_Name__c)){
                            sectionName = questionVal.dd_Section_Name__c;
                            sectionNumberQuestionAnswerMap = new Map<String, String>();
                        }
                        isMultipleAnswerSection = true;
                        List<String> answerList = questionVal.dd_Answer__c.split(',', -1);
                        system.debug('answerList ::' +answerList);
                        system.debug('answerList.size() ::' +answerList.size());
                        Integer size = answerList.size();
                        for(Integer i=0; i< size; i++){
                            if(String.isEmpty(answerList.get(i))){
                                replaceQAnswer = 'None';
                            }
                            else{
                                replaceQAnswer = answerList.get(i);
                            }
                            system.debug('replaceQAnswer ::' +replaceQAnswer);
                            if(sectionNumberQuestionAnswerMap.containsKey(questionVal.dd_Section_Name__c+String.valueOf(i))){
                                String value = sectionNumberQuestionAnswerMap.get(questionVal.dd_Section_Name__c+String.valueOf(i));
                            	sectionNumberQuestionAnswerMap.put(questionVal.dd_Section_Name__c+String.valueOf(i), value+'__2'+questionVal.dd_Question__c+'__1'+replaceQAnswer);    
                            }  
                            else
                            {
                                sectionNumberQuestionAnswerMap.put(questionVal.dd_Section_Name__c+String.valueOf(i), questionVal.dd_Question__c+'__1'+replaceQAnswer);
                            }
                            system.debug('sectionNumberQuestionAnswerMap after :: '+sectionNumberQuestionAnswerMap);                            
                        }                                                
                        sectionName_SectionNumberQuestionAnswerMap.put(questionVal.dd_Section_Name__c, sectionNumberQuestionAnswerMap);        
                        system.debug('sectionName_SectionNumberQuestionAnswerMap after :: '+sectionName_SectionNumberQuestionAnswerMap);
                    }
                    else{*/
                        if(questionVal.dd_Answer__c != null){
                            replaceQAnswer = questionVal.dd_Answer__c.split('\n');
                        }
                        /*else{
                            
                        }*/
                    //} 
                    system.debug('questionVal.dd_Question__c  :: '+questionVal.dd_Question__c );
                    system.debug('replaceQAnswer ::' + replaceQAnswer );                   
                    if(!pdfContent.contains(questionVal.dd_Section_Name__c) && !isMultipleAnswerSection){
                        pdfContent = pdfContent + '<tr><th><h2>'+questionVal.dd_Section_Name__c+'</h2></th><td></td></tr>';
                    }
                    if(!isMultipleAnswerSection){                         
                        pdfContent = pdfContent + '<tr>';
                        pdfContent = pdfContent + '<th>' + questionVal.dd_Question__c + '</th>'+'<td>';
                            for(String replaceQAnswerVal : replaceQAnswer){
                                system.debug('replaceQAnswerVal :: '+replaceQAnswerVal);
                                if(replaceQAnswerValFinal == ''){
                                    replaceQAnswerValFinal = replaceQAnswerVal+'<br/>';
                                }
                                else{
                                    replaceQAnswerValFinal +=  replaceQAnswerVal+'<br/>';
                                }                                
                            }  
                        pdfContent = pdfContent + replaceQAnswerValFinal + '</td>'+ '</tr>';
                    }
                    system.debug('pdfContent after each question :: '+pdfContent); 
                }
                system.debug('pdfContent after for loop :: '+pdfContent);  
                system.debug('sectionNumberQuestionAnswerMap :: '+sectionNumberQuestionAnswerMap);
                system.debug('sectionName_SectionNumberQuestionAnswerMap :: '+sectionName_SectionNumberQuestionAnswerMap);
                pdfContent = pdfContent + '</tbody></table>';
                
                for(String value : sectionName_SectionNumberQuestionAnswerMap.keyset()){
                    String finalVal = '';
                    system.debug('value :: '+value);
                    if(!finalVal.contains(value)){
                        finalVal = finalVal + '<table><tbody><tr><th><h2>'+value+'</h2></th><td>Response</td></tr>';
                    }
                    //String finalVal = '<h2>'+value+'</h2>';
                    system.debug('finalVal ::'+ finalVal);
                    Map<String, String> sectionNumberQuestionAnswerFetchedMap = sectionName_SectionNumberQuestionAnswerMap.get(value);
                    system.debug('sectionNumberQuestionAnswerFetchedMap ::'+ sectionNumberQuestionAnswerFetchedMap);
                    for(String value1 : sectionNumberQuestionAnswerFetchedMap.keySet()){
                        system.debug('value1 ::'+ value1);
                        List<String> questionAnswerList = sectionNumberQuestionAnswerFetchedMap.get(value1).split('__2');
                        system.debug('questionAnswerList ::'+ questionAnswerList);
                        for(String questionAnswerVal : questionAnswerList){
                            system.debug('questionAnswerVal ::'+ questionAnswerVal);
                            List<String> questionAnswerSplit = questionAnswerVal.split('__1');
                            system.debug('questionAnswerSplit ::'+ questionAnswerSplit);
                            finalVal = finalVal + '<tr><th>' + questionAnswerSplit.get(0) + '</th><td>'+questionAnswerSplit.get(1) +'</td></tr>';                    
                        }    
                        finalVal = finalVal + '<tr><th></th><td></td></tr>';
                    } 
                    pdfContent = pdfContent + finalVal + '</tbody></table>';
                    system.debug('finalVal outside inner loop ::'+ finalVal);
                    //pdfContent = pdfContent.replace(value, finalVal);
                    system.debug('pdfContent outside inner loop ::'+ pdfContent);
                    //finalVal = '';
                }
                system.debug('pdfContent outside outer loop ::'+ pdfContent);
                pdfContent = pdfContent + '</section></main></div>';
                pdfContent = pdfContent + formHtmlEnd;
                system.debug(' final pdfContent :: '+pdfContent);
                //newMap.get(queriedQRVal.Id).DD_Counterparty_Email__c = queriedQRVal.dd_Assessment__r.Contact.Email;
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            system.debug('Final PDF ::'+ pdfContent);
            attach.parentId = queriedQRVal.Id;
            //attach.Name = 'Submitted Response' + '.pdf';
            //attach.body = Blob.toPDF(pdfContent); //This creates the PDF content Blob.valueof(myString);
   			attach.Name = 'Submitted Response' + '.html';
            attach.body = Blob.valueof(pdfContent);
            attach.IsPrivate = false;
            attachList.add(attach);
        }
                
        if(attachList.size()>0){
            try{
                insert attachList;
            }
            catch(DMLException ex){
                system.debug('Exception occurred while trying to attach PDF to Questionnaire response');
            }
        }
        
        if(csId_cs_Map.size()>0){
            try{
                update csId_cs_Map.values();
            }
            catch(DMLException ex){
                system.debug('Exception occurred while trying to update Case from Questions update');
            }
        }
                
    system.debug('DDQuestionaireResponseTriggerHandler :: beforeUpdate :: end');
    }
    
    public void afterUpdate(list<dd_Questionnaire_Response__c> qrList, Map<Id, dd_Questionnaire_Response__c > newMap, Map<Id, dd_Questionnaire_Response__c> oldMap){
        
        List<Id> qrIdToShareList = new List<Id>();
        List<Id> contactIdList = new List<Id>();        
        
        for(dd_Questionnaire_Response__c qrVal : qrList){
            if(newMap.get(qrVal.Id).OwnerId != oldMap.get(qrVal.Id).OwnerId){
                qrIdToShareList.add(qrVal.Id);                             
            }           
        }
        
        system.debug('qrIdToShareList :: '+qrIdToShareList);
                
        List<dd_Questionnaire_Response__c> queriedQRToShareList = [select Id, dd_Assessment__r.Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c, 
                                    dd_Assessment__r.Contact.OwnerId, dd_Assessment__r.Contact.Account.CreatedById, dd_Assessment__r.ContactId,
                                    dd_Assessment__r.Contact.Account.ParentId, dd_Assessment__r.Account.ParentId from dd_Questionnaire_Response__c 
                                    where Id in: qrIdToShareList];
                                    
        for(dd_Questionnaire_Response__c queriedQRVal : queriedQRToShareList){
            if(newMap.get(queriedQRVal.Id).OwnerId != oldMap.get(queriedQRVal.Id).OwnerId){
                contactIdList.add(queriedQRVal.dd_Assessment__r.ContactId);                                
            }            
        }
        
        system.debug('contactIdList :: '+contactIdList);
        
        if(qrIdToShareList.size()>0 && contactIdList.size()>0){
            reCalculateSharingRuleOnOwnerChange(queriedQRToShareList, contactIdList);
        }
        
    }
    
    private void reCalculateSharingRuleOnOwnerChange(List<dd_Questionnaire_Response__c> queriedQRToShareList, List<Id> contactIdList){
        
        CaseTriggerHandler csTrgHandler = new CaseTriggerHandler();
        Map<Id,Id> caseIdUserIdMap = new Map<Id,Id>();
        Map<Id,User> contactIdUserMap = new Map<Id, User>();
        
        // Query the related Users from the contacts
        List<User> usrList = [select Id, ContactId from User where ContactId in: contactIdList];        
        
        // Query to fetch the license type on the functional account
        List<Case> case1List = [select Id, ContactId, Contact.Account.Parent.DD_Due_Diligence_Portal_Licence__c 
                                        from Case where ContactId in: contactIdList];
                                        
        for(User userVal : usrList){
            contactIdUserMap.put(userVal.ContactId, userVal);
        }
        
        for(Case caseVal : case1List){
            if(contactIdUserMap.get(caseVal.ContactId) != null)
            caseIdUserIdMap.put(caseVal.Id, contactIdUserMap.get(caseVal.ContactId).Id);
        }
        if(queriedQRToShareList.size() > 0 &&  caseIdUserIdMap.size() > 0)
        csTrgHandler.shareWithPartnerOrVerificationTeam(queriedQRToShareList, caseIdUserIdMap);
    }        
}