﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">

    protected void LinkButton1_Click(object sender, EventArgs e)
    {

    }

    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {

    }

    protected void gridProducts_RowEditing(object sender, GridViewEditEventArgs e)
    {
        //Get current row
        GridViewRow row = gridProducts.Rows[e.NewEditIndex];

        //Get the current product ID
        int rowId = Convert.ToInt32(row.Cells[1].Text);

        //Redirect user to the manager page
        Response.Redirect("~/webpages/Store/Admin/ManageProducts.aspx?id=" + rowId);
    }

    protected void gridProducts_RowDeleting(object sender, GridViewEditEventArgs e)
    {
        try
        {

        }
        catch (Exception ex) { }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (TaxTextBox.Text == "")
        {
            TaxShippingModel model = new TaxShippingModel();

            TaxTextBox.Text = "" + model.GetTaxShipping().Tax;
            ShippingTextBox.Text = "" + model.GetTaxShipping().Shipping;
        }

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {
            YWC_StorageEntities db = new YWC_StorageEntities();
            TaxShippingModel model = new TaxShippingModel();
            string newTax;
            string newShipping;

            newTax = TaxTextBox.Text;
            newShipping = ShippingTextBox.Text;

            TaxShipping tasShip = new TaxShipping();

            tasShip.Tax = Convert.ToDouble(newTax).ToString();
            tasShip.Shipping = Convert.ToDouble(newShipping).ToString();

            model.UpdateInfo(tasShip);

            Literal1.Text = "Changes Saved Successfully : Tax = " + tasShip.Tax + " Shipping = " + tasShip.Shipping;
        }

        catch(Exception ex2)
        {
            Literal1.Text = "ERROR : " + ex2;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent1" Runat="Server">
        <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="15pt" Text="Store Management"></asp:Label>
        <br />
        <br />
        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="button" PostBackUrl="~/webpages/Store/Admin/ManageProducts.aspx" OnClick="LinkButton1_Click">Add New Item</asp:LinkButton>
        <br />
        <br />
        <asp:GridView ID="gridProducts" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="sdsProducts" Width="100%" OnRowEditing="gridProducts_RowEditing" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Vertical" HorizontalAlign="Center">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
                <asp:BoundField DataField="TypeId" HeaderText="TypeId" SortExpression="TypeId" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
                <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
                <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                <asp:BoundField DataField="Image" HeaderText="Image" SortExpression="Image" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
                <asp:BoundField DataField="Stock" HeaderText="Stock" SortExpression="Stock">
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <RowStyle BackColor="#F7F7DE" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#FBFBF2" />
            <SortedAscendingHeaderStyle BackColor="#848384" />
            <SortedDescendingCellStyle BackColor="#EAEAD3" />
            <SortedDescendingHeaderStyle BackColor="#575357" />
        </asp:GridView>
        <asp:SqlDataSource ID="sdsProducts" runat="server" ConnectionString="<%$ ConnectionStrings:StoreConnectionString %>" DeleteCommand="DELETE FROM [Product] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Product] ([TypeId], [Name], [Price], [Description], [Image]) VALUES (@TypeId, @Name, @Price, @Description, @Image)" SelectCommand="SELECT * FROM [Product]" UpdateCommand="UPDATE [Product] SET [TypeId] = @TypeId, [Name] = @Name, [Price] = @Price, [Description] = @Description, [Image] = @Image WHERE [Id] = @Id">
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="TypeId" Type="Int32" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="Price" Type="Double" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Image" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="TypeId" Type="Int32" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="Price" Type="Double" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Image" Type="String" />
                <asp:Parameter Name="Id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <br />
        <asp:LinkButton ID="LinkButton2" runat="server" PostBackUrl="~/webpages/Store/Admin/ManageProductTypes.aspx">Add new Category</asp:LinkButton>
        <br />
        <br />
        <asp:GridView ID="gridProductsTypes" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="sdsProductTypes" Width="50%" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" ForeColor="Black" GridLines="Vertical">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="Id" HeaderText="Id" InsertVisible="False" ReadOnly="True" SortExpression="Id" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" >
                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                </asp:BoundField>
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <RowStyle BackColor="#F7F7DE" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#FBFBF2" />
            <SortedAscendingHeaderStyle BackColor="#848384" />
            <SortedDescendingCellStyle BackColor="#EAEAD3" />
            <SortedDescendingHeaderStyle BackColor="#575357" />
        </asp:GridView>
        <asp:SqlDataSource ID="sdsProductTypes" runat="server" ConnectionString="<%$ ConnectionStrings:StoreConnectionString %>" DeleteCommand="DELETE FROM [ProductTypes] WHERE [Id] = @Id" InsertCommand="INSERT INTO [ProductTypes] ([Name]) VALUES (@Name)" SelectCommand="SELECT * FROM [ProductTypes]" UpdateCommand="UPDATE [ProductTypes] SET [Name] = @Name WHERE [Id] = @Id">
            <DeleteParameters>
                <asp:Parameter Name="Id" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="Name" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="Id" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <br />
        Tax Amount :<br />
        <br />
        <asp:TextBox ID="TaxTextBox" runat="server" Width="180px"></asp:TextBox>
        <br />
        <br />
        Shipping Price :<br />
        <br />
        <asp:TextBox ID="ShippingTextBox" runat="server" Width="179px"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="Button1" runat="server" CssClass="button" Text="Save Changes" OnClick="Button1_Click" />
        <br />
        <asp:Literal ID="Literal1" runat="server"></asp:Literal>
        <asp:SqlDataSource ID="taxsource" runat="server"></asp:SqlDataSource>
        <br />
</asp:Content>

