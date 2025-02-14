﻿   <%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //Only load images when opened for the first time
        if (!IsPostBack)
        {
            getImages();

            if (!String.IsNullOrWhiteSpace(Request.QueryString["id"]))
            {
                int id = Convert.ToInt32(Request.QueryString["id"]);
                FillPage(id);
            }
        }
    }

    protected void buttonAdd_Click(object sender, EventArgs e)
    {
        ProductModel productModel = new ProductModel();
        Product product = createProduct();

        //Check if editing
        if (!String.IsNullOrWhiteSpace(Request.QueryString["id"]))
        {
            //ID Exists - update row
            int id = Convert.ToInt32(Request.QueryString["id"]);
            labelResult.Text = productModel.UpdateProduct(id,product);
        }
        else
        {
            //ID does not exist - create new row
            labelResult.Text = productModel.InsertProduct(product);
        }
    }

    private void FillPage(int id)
    {
        //Get all data from DB to Page
        ProductModel productmodel = new ProductModel();
        Product product = productmodel.GetProduct(id);

        //Fill Textboxes
        textDescription.Text = product.Description;
        textName.Text = product.Name;
        textPrice.Text = product.Price.ToString();
        textboxStock.Text = product.Stock.ToString();

        //Fill dropdown list
        dropDownImage.SelectedValue = product.Image;
        dropDownType.SelectedValue = product.TypeId.ToString();


    }

    private void getImages()
    {
        try
        {
            //Get paths from files
            string[] images = System.IO.Directory.GetFiles(Server.MapPath("~/Images/Products/"));

            //Get filenames and add to ArrayList
            ArrayList imageList = new ArrayList();
            foreach (string image in images)
            {
                string imageName = image.Substring(image.LastIndexOf(@"\", StringComparison.Ordinal) + 1);
                imageList.Add(imageName);
            }

            //Set Arraylist as the datasource for dropdown
            dropDownImage.DataSource = imageList;
            dropDownImage.AppendDataBoundItems = true;
            dropDownImage.DataBind();
        }
        catch(Exception e)
        {
            labelResult.Text = e.ToString();
        }
    }

    private Product createProduct()
    {
        Product product = new Product();

        product.Name = textName.Text;
        product.Price = Convert.ToDouble(textPrice.Text);
        product.TypeId = Convert.ToInt32(dropDownType.SelectedValue);
        product.Description = textDescription.Text;
        product.Image = dropDownImage.SelectedValue;
        product.Stock = Convert.ToInt32(textboxStock.Text);

        return product;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {

        if (FileUploadImages.HasFile)
        {
            FileUploadImages.SaveAs(Request.PhysicalApplicationPath + "/Images/Products/" + FileUploadImages.FileName.ToString());
            litUploadStatus.Visible = true;
            litUploadStatus.Text = "Image Uploaded successfully.";
            dropDownImage.DataBind();
            //Response.Redirect("~/webpages/Store/Admin/ManageProducts.aspx");
            
        }
        else
        {
            litUploadStatus.Visible = true;
            litUploadStatus.Text = "Error : No Image File Selected";
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        #form1 {
            margin-left: 21px;
            margin-top: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent1" Runat="Server">
    <form id="form1">
        <p>
            Product Name:</p>
        <p>
            <asp:TextBox ID="textName" runat="server" Width="310px"></asp:TextBox>
        </p>
        <p>
            Description:</p>
        <p>
            <asp:TextBox ID="textDescription" runat="server" Height="164px" TextMode="MultiLine" Width="777px"></asp:TextBox>
        </p>
        <p>
            Product Type:</p>
        <p>
            <asp:DropDownList ID="dropDownType" runat="server" DataSourceID="ProductType_SqlDataSource" DataTextField="Name" DataValueField="Id">
            </asp:DropDownList>
            <asp:SqlDataSource ID="ProductType_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:StoreConnectionString %>" SelectCommand="SELECT * FROM [ProductTypes] ORDER BY [Name]"></asp:SqlDataSource>
        </p>
        <p>
            Price:</p>
        <p>
            <asp:TextBox ID="textPrice" runat="server" Width="187px"></asp:TextBox>
        </p>
        <p>
            Select Image:</p>
        <p>
            <asp:DropDownList ID="dropDownImage" runat="server" Height="42px" Width="174px">
            </asp:DropDownList>
        </p>
        <p>
            Upload Image:</p>
        <p>
        &nbsp;<asp:Button ID="Button1" runat="server" Height="24px" OnClick="Button1_Click" Text="Add Image" Width="99px" />
            <asp:FileUpload ID="FileUploadImages" runat="server" />
        </p>
        <p style="font-size :x-small">
            Note : Uploading new Images would refresh the page and may result in unsaved changes being lost.</p>
        <p>
            <asp:Literal ID="litUploadStatus" runat="server"></asp:Literal>
        </p>
        <p>
            Stock:</p>
        <p>
            <asp:TextBox ID="textboxStock" runat="server" Width="84px"></asp:TextBox>
        </p>
        <p>
            <asp:Button ID="buttonAdd" runat="server" Text="Add Product" OnClick="buttonAdd_Click" />
        </p>
        <p>
            <asp:Label ID="labelResult" runat="server"></asp:Label>
        </p>
    </form>
</asp:Content>

