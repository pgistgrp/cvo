infoObject.currentFilter = '';

infoObject.getConcerns = function(page, filter) {
  if (filter) {
    if (filter>0) {
      this.currentFilter = filter;
    } else {
      this.currentFilter = '';
    }
  }
  
  displayIndicator(true);
  BCTAgent.getConciseConcerns({bctId: this.targetId, filter: this.currentFilter, count:10, page: page, sorting: $('selectsort').value}, this.wfinfo,{
      callback:function(data){
          displayIndicator(false);
          if (data.successful){
              $('concernsPanel').innerHTML = data.html;
              if (data.filter) {
                infoObject.currentFilter = data.filter.id;
                $('filterSpan').innerHTML = data.filter.tag.name;
                $('filterDiv').style.display = 'inline';
              } else {
                this.currentFilter = '';
                $('filterDiv').style.display = 'none';
              }
          }else{
              alert(data.reason);
          }
      },
      errorHandler:function(errorString, exception){ 
          alert("get concerns error: " + errorString +" "+ exception);
      }
  });
};

infoObject.getTags = function(page) {
  displayIndicator(true);
  BCTAgent.getConciseTags({bctId:this.targetId, page:page, sorting:$('tagsort').value}, this.wfinfo,{
      callback:function(data){
          displayIndicator(false);
          if (data.successful){
              $('tagsPanel').innerHTML = data.html;
              $('tagsort').value = data.sorting;
          }else{
              alert(data.reason);
          }
      },
      errorHandler:function(errorString, exception){ 
          alert("get tags error: " + errorString +" "+ exception);
      }
  });
};

infoObject.loadTarget = function() {
  this.getConcerns(1);
  this.getTags(1);
};
