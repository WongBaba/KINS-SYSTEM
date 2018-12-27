using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using KINS_SYSTEM.ImportClass;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;

namespace KINS_SYSTEM.Pages.PurchasingManagement
{
    /// <summary>
    /// PurchasingAddnew1 的摘要说明
    /// </summary>
    public class PurchasingAddnew1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            data.company = context.Session["company"].ToString();
            context.Response.Write(addPurchasing(data));
        }

        private int addPurchasing(Data data)
        {
            string sqlStr = "";
            int arraySize = data.A_Pc_parameter.Length;
            for (int i = 0; i < arraySize; i++)
            {
                data.Pc_parameter = data.A_Pc_parameter[i];
                data.Pc_purpose = data.A_Pc_purpose[i];
                data.Pc_quantity = data.A_Pc_quantity[i];
                data.Pc_typeId = data.A_Pc_typeId[i];
                data.Pc_unitPrice = data.A_Pc_unitPrice[i];
                data.Pc_remarks = data.A_Pc_remarks[i];
                if (data.Pc_Method.IndexOf("入库") > -1)
                    sqlStr += addInventory(data);
                if (data.Pc_Method.IndexOf("入账") > -1)
                    sqlStr += addFinancial(data);
                sqlStr += getPurchasing(data);
            }
            DbSql ds = new DbSql();
            //将数据添加进采购管理数据表中
            
            if (!ds.ExecSql(sqlStr))
                return 0;
            return 2;
        }
        private string getPurchasing(Data data) {
            string sqlStr = "INSERT INTO K_Purchasing (Pc_Method, Pc_date, Pc_manufacturerId, Pc_typeId, Pc_parameter, Pc_unitPrice, Pc_quantity, Pc_purpose, Pc_operator, Pc_remarks,Pc_company) VALUES ('" +
                data.Pc_Method + "', '" + data.Pc_date + "', '" + data.Pc_manufacturerId + "', '" + data.Pc_typeId + "', '" + data.Pc_parameter + "', '" + data.Pc_unitPrice +
                "', '" + data.Pc_quantity + "', '" + data.Pc_purpose + "', '" + data.Pc_operator + "', '" + data.Pc_remarks + "', '" + data.company + "')";
            return sqlStr;
        }

        private string addInventory(Data data)
        {
            DbSql ds = new DbSql();
            //检查该条数据是否已存在
            string sqlStr = "select * from K_component where Cp_company='" + data.company + "' and Cp_manufacturerId='" + data.Pc_manufacturerId + "' and Cp_typeId='" + data.Pc_typeId + "' and Cp_parameter='" + data.Pc_parameter + "'";
            DataTable da = new DataTable();
            da = ds.FillDt(sqlStr);
            //如果改数据已存在则添加库存，如果不存在新增零件并填写数据
            if (da.Rows.Count > 0)
            {
                double price = (double.Parse(data.Pc_unitPrice) * double.Parse(data.Pc_quantity) + double.Parse(da.Rows[0]["Cp_price"].ToString()) * double.Parse(da.Rows[0]["Cp_inventory"].ToString())) /
                    (double.Parse(data.Pc_quantity) + double.Parse(da.Rows[0]["Cp_inventory"].ToString()));
                sqlStr = "UPDATE K_Component SET Cp_inventory='" + (double.Parse(data.Pc_quantity) + double.Parse(da.Rows[0]["Cp_inventory"].ToString())).ToString("0.00") + "',Cp_price='" + price.ToString("0.00") + "' ";
                sqlStr += "where Cp_id='" + da.Rows[0]["Cp_id"].ToString() + "' ";
            }
            else
            {
                sqlStr = "INSERT INTO K_Component (Cp_typeId, Cp_manufacturerId, Cp_parameter,  Cp_price, Cp_inventory, Cp_remarks,Cp_company) VALUES ('"
                    + data.Pc_typeId + "','" + data.Pc_manufacturerId + "','" + data.Pc_parameter + "','" + data.Pc_unitPrice + "','" + data.Pc_quantity + "','" + data.Pc_remarks + "','" + data.company + "')";
            }
            return sqlStr;
        }
        private string addFinancial(Data data)
        {
            DbSql ds = new DbSql();
            //根据供应商id和零件类型id获取，供应商公司名字和类型名字
            string sqlStr = "select Co_abbreviation from K_info_Company where Co_company='" + data.company + "' and Co_id='" + data.Pc_manufacturerId + "' ";
            sqlStr += "select Tp_name from k_ProductType where Tp_company='" + data.company + "' and Tp_id='" + data.Pc_typeId + "'";
            DataSet dset = new DataSet();
            dset = ds.FillDs(sqlStr);
            //将数据自动添加进财务管理的进账
            if (data.Pc_Method.IndexOf("月结") > -1)
            {
                data.Ol_state = "待出账";
            }
            sqlStr = " insert into K_Outlay (Ol_payDate,Ol_payee,Ol_payMethod,Ol_money,Ol_content,Ol_operator,Ol_remarks,Ol_company,Ol_state) values ('"
                + data.Pc_date + "','" + dset.Tables[0].Rows[0][0] + "','" + "现金" + "','" + (Double.Parse(data.Pc_unitPrice) * Double.Parse(data.Pc_quantity)).ToString("0.00") + "','" +
                "【采购】【" + dset.Tables[1].Rows[0][0] + "】" + data.Pc_parameter + "|数量：" + data.Pc_quantity + "|单价：" + data.Pc_unitPrice + "|用途:" + data.Pc_purpose + "','" + data.Pc_operator + "','" + data.Pc_remarks + "','" + data.company + "','" + data.Ol_state + "')";
            return sqlStr;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        public class Data
        {
            public string Pc_Method, Pc_date, Pc_manufacturerId, company = "", Pc_operator, Ol_state = "出账";
            public string[] A_Pc_parameter, A_Pc_unitPrice, A_Pc_quantity, A_Pc_purpose, A_Pc_remarks;
            public List<string> A_Pc_typeId=new List<string>();
            public string Pc_typeId, Pc_parameter, Pc_unitPrice, Pc_quantity, Pc_purpose, Pc_remarks;
        }
    }
}