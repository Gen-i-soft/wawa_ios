class DocObj{
  var documentName;
  var documentUrl;
  var documentId;


  DocObj(DocObj doc){
    this.documentName = doc.getDocName();
    this.documentUrl = doc.getDocUrl();
    this.documentId = doc.getDocId();
  }

  dynamic getDocName () => documentName;
  dynamic getDocUrl () => documentUrl;
  dynamic getDocId () => documentId;

  DocObj.setDetails(Map<dynamic, dynamic>? doc){
     documentName = doc!['name'];
     documentUrl = doc['urlImage'];
     documentId = doc['id'];
  }


}