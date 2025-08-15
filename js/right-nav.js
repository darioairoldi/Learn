<script>
// Custom right navigation for Quarto site
document.addEventListener('DOMContentLoaded', function() {
  console.log('Custom right navigation loading...');
  
  // Wait for Quarto to fully initialize
  setTimeout(function() {
    addRightNavigation();
  }, 500);
  
  // Also try on window load as backup
  window.addEventListener('load', function() {
    setTimeout(addRightNavigation, 200);
  });
  
  function addRightNavigation() {
    const marginSidebar = document.getElementById('quarto-margin-sidebar');
    console.log('Margin sidebar found:', !!marginSidebar);
    
    if (!marginSidebar) {
      console.log('No margin sidebar found');
      return;
    }
    
    // Check if already added
    if (marginSidebar.querySelector('.custom-right-nav-container')) {
      console.log('Right nav already exists');
      return;
    }
    
    const rightNavHTML = `
      <div class="custom-right-nav-container">
        <div class="custom-toc-addition">
          <h3>?? Quick Navigation</h3>
          <ul>
            <li><a href="20250712 Use QUARTO doc for Github repos doc/README.html">?? Quarto Guide</a></li>
            <li><a href="20250713 Use http files for easy and repeatable test/README.html">?? HTTP Testing</a></li>
            <li><a href="20250709 Manage GitRepo from commandline/README.html">?? Git Commands</a></li>
            <li><a href="20250704 TableStorageAccess options/README.html">??? Table Storage</a></li>
          </ul>
        </div>
        
        <div class="custom-toc-addition" style="margin-top: 1rem;">
          <h3>?? Azure Resources</h3>
          <ul>
            <li><a href="20250702 Azure Naming conventions/README.html">?? Naming Conventions</a></li>
            <li><a href="20250706 CosmosDB Access options/README.html">?? CosmosDB Guide</a></li>
          </ul>
        </div>
        
        <div class="custom-toc-addition" style="margin-top: 1rem;">
          <h3>?? Build 2025</h3>
          <ul>
            <li><a href="202506 Build 2025/BRK106/00. Elevating Development with .NET Aspire AI, Cloud, and Beyond.html">?? .NET Aspire AI</a></li>
            <li><a href="202506 Build 2025/BRK122/00. The Future of Web Development with ASP.NET Core & Blazor.html">?? ASP.NET Core</a></li>
            <li><a href="202506 Build 2025/BRK123/00. AI infused mobile & desktop app development with .NET MAUI.html">?? .NET MAUI AI</a></li>
          </ul>
        </div>
      </div>
    `;
    
    marginSidebar.insertAdjacentHTML('beforeend', rightNavHTML);
    console.log('Right navigation added successfully');
  }
});
</script>