using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.SessionState;
using System.Runtime.Serialization;
using System.Web.Script.Serialization;
using System.IO;
using System.Net;


namespace KINS_SYSTEM.Pages.OperationCourse
{
    /// <summary>
    /// GetCourses 的摘要说明
    /// </summary>
    public class GetCourses : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            Data data = jss.Deserialize<Data>(context.Request["data"].ToString());
            string[] files = Directory.GetFiles(System.Web.HttpContext.Current.Server.MapPath("/")+data.path);
            //对初始数据进行筛选
            int fileLength = files.Length;
            for (int i = 0; i < fileLength; i++)
            {
                files[i] = files[i].Split('\\')[files[i].Split('\\').Length - 1];
                if (files[i].IndexOf("课") == -1)
                {
                    files[i] = files[fileLength - 1];
                    fileLength--;
                    i--;
                }
            }
            int[] a = new int[fileLength];
            for (int i = 0; i < fileLength; i++)
            {
                a[i] = int.Parse(files[i].Split(' ')[0].Replace("课时", "|").Split('|')[1]);
            }

            //课时排序
            for (int i = 0; i < a.Length; i++)
            {
                //这个是和第一个数的比较的数
                for (int j = i + 1; j < a.Length; j++)
                {
                    //定义一个临时的变量，用来交换变量
                    int temp;
                    string temps;
                    if (a[i] > a[j])
                    {
                        temp = a[i];
                        a[i] = a[j];
                        a[j] = temp;

                        temps = files[i];
                        files[i] = files[j];
                        files[j] = temps;
                    }
                }
            }
            string course = files[0];
            for (int i = 1; i < fileLength; i++)
                course += "|" + files[i];
            context.Response.Write(course);
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
            public string path;
        }
    }
}