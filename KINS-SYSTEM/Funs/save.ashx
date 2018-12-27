<%@ WebHandler Language="C#" Class="save" %>

using System;
using System.Web;
using System.IO;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;

public class save : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        JavaScriptSerializer jss = new JavaScriptSerializer();
        Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
        string path = System.AppDomain.CurrentDomain.BaseDirectory;
        saves(path+"funs/db/history.txt", data.history);
        saves(path+"funs/db/jifen.txt", data.jifen);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    private void saves(string path,string str)
    {
        //文件路径
        string filePath = @"E:\123\456.txt";

        //定义编码方式，text1.Text为文本框控件中的内容
        byte[] mybyte = System.Text.Encoding.UTF8.GetBytes(str);
        string mystr1 = System.Text.Encoding.UTF8.GetString(mybyte);

        //写入文件
        //File.WriteAllBytes(filePath,mybyte);//写入新文件
        //File.WriteAllText(filePath, mystr1);//写入新文件
        File.WriteAllText(path, mystr1);//添加至文件
    }
    
    public class Data
    {
        public string history="";
        public string jifen="";
    }

}