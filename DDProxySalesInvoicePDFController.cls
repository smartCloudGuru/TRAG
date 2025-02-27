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

 Code purpose  : name the Proxy Invoice PDF and render it


 Birthday      : 22/07/2014
 Api version   : v31

 ****************************************************************************************************************************/


public class DDProxySalesInvoicePDFController{

public string renderAs{get;set;}
    
    // Constructor to name the Proxy Invoice PDF
    public DDProxySalesInvoicePDFController(ApexPages.StandardController controller) {
        
        system.debug('DDProxySalesInvoicePDFController :: DDProxySalesInvoicePDFController :: start');
        renderAs = 'pdf';
        string fileName = 'MyInvoice'+date.today()+'.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename='+fileName);
        system.debug('DDProxySalesInvoicePDFController :: DDProxySalesInvoicePDFController :: end');           
    }

}