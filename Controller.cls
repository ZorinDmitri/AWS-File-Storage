List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId = '0019X00000DfVK2QAN'];
Set<Id> ids=new Set<Id>();
for(ContentDocumentLink link:links)
{
ids.add(link.ContentDocumentId);
}
List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
if (versions.size() > 0) {
String attachmentBody = EncodingUtil.base64Encode(versions[0].VersionData);
system.debug('file:'+ versions[0]);
String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
String fileName = versions[0].Title;
string contentType= 'application/pdf';
system.debug('contentType:' + contentType);
String url = 'callout:AWSS3/';
HttpRequest req  = new HttpRequest();
HttpResponse res  = new HttpResponse();
req.setMethod('PUT');
req.setEndpoint(url + filename);
req.setHeader('Content-Encoding', 'UTF-8');
req.setHeader('Content-type', contentType);
req.setHeader('Connection', 'keep-alive');
req.setHeader('Date', formattedDateString);
req.setHeader('ACL', 'public-read');
Blob pdfBlob = EncodingUtil.base64Decode(attachmentBody);
req.setBodyAsBlob(pdfBlob); 
Http http = new Http();
res = http.send(req);
system.debug(res.getStatusCode());
system.debug(res.getBody());
}
