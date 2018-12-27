using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/**********************************************************
#I00  Index.aspx

AttendanceManagement
#A01  AttendanceManagement/AttendanceManagement.aspx   个人中心的考勤查看
#A02  AttendanceManagement/CheckIn.aspx	 打卡页面(后台自动打卡)

ComponentManagement
#C01  ComponentManagement/AddCompany.aspx	添加合作供应商信息
#C02  ComponentManagement/AddComponent.aspx	添加新零配件信息
#C03  ComponentManagement/AddComponentType.aspx		添加新零配件类型
#C04  ComponentManagement/ComponentManagement.aspx	零配件综合管理
#C05  ComponentManagement/DelCompany.aspx	删除合作供应商信息
#C06  ComponentManagement/DelComponent.aspx	删除零配件信息
#C07  ComponentManagement/DelComponentType.aspx		删除零配件类型信息
#C08  ComponentManagement/EditComponent.aspx		编辑零配件信息

OrderManagement
#O01  OrderManagement/ImportOrder.aspx		导入订单至数据库
#O01  OrderManagement/QueryOrder.aspx		查找订单信息

ProductManagement
#P01  ProductManagement/AddProduct.aspx		添加新产品
#P02  ProductManagement/AddProductSku.aspx	添加新产品SKU
#P03  ProductManagement/AddProductType.aspx	添加新产品类型
#P04  ProductManagement/DelProduct.aspx		删除产品信息
#P05  ProductManagement/DelProductSku.aspx	删除产品SKU
#P06  ProductManagement/ProductManagement.aspx	产品信息综合管理
#P07  ProductManagement/ProductSKU.aspx		产品SKU信息综合管理

StaffManagement
#S01  StaffManagement/AttendanceManagement.aspx	员工考勤综合管理
#S02  StaffManagement/EditAttendance.aspx	编辑员工考勤信息
#S03  StaffManagement/EditStaff.aspx		编辑员工基本信息
#S04  StaffManagement/OffJob.aspx		员工离职
#S05  StaffManagement/OnJob.aspx		员工入职
#S06  StaffManagement/OnOffJob.aspx		员工离职入职综合管理

**********************************************************/



namespace KINS_SYSTEM.Pages
{
    public partial class NoPermission : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["yhm"] == null)
                {
                    Response.Redirect("~/Pages/Login.aspx");
                }
            }
        }
    }
}