using System;
using System.Net.Http;
using System.Threading;

const string URL_PREFIX = "https://photos.app.goo.gl/";
const string GOOGLE_CONTENT_PREFIX = "https://lh3.googleusercontent.com/";

CancellationTokenSource cancellationTokenSource = new();
ConsoleCancelEventHandler sessionCanceler = (sender, e) =>
{
    e.Cancel = true; // Execution continues after the delegate.
    cancellationTokenSource.Cancel();
};
Console.CancelKeyPress += sessionCanceler;


if (Args.Count != 1)
{
    Console.WriteLine("error: Expecting one argument.");
    return;
}

try
{
    string baseUrl = Args[0];

    if (!baseUrl.StartsWith(URL_PREFIX))
    {
        Console.WriteLine($"error: URL does not start with '{URL_PREFIX}'.");
        return;
    }

    HttpClient httpClient = new HttpClient();
    var response = await httpClient.GetAsync(baseUrl, cancellationTokenSource.Token);
    List<string> filteredLines = new();
    if (response.IsSuccessStatusCode)
    {
        var data = await response.Content.ReadAsStringAsync(cancellationTokenSource.Token);
        response.Dispose();
        httpClient.Dispose();
        if ((data is not null) && (data.Length > 0))
        {
            List<string> lines = new(data.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None));
            filteredLines = lines.FindAll(line => { return line.Contains(GOOGLE_CONTENT_PREFIX); });
        }
        else
        {
            Console.WriteLine("error: Empty response from server.");
            return;
        }
    }
    else
    {
        Console.WriteLine("error: " + response.StatusCode.ToString());
        return;
    }

    if (filteredLines.Count == 0)
    {
        Console.WriteLine("error: Unrecognized response from server.");
        return;
    }

    List<string> filteredPrefix = new();
    filteredLines.ForEach(line => filteredPrefix.Add(line.Substring(line.IndexOf(GOOGLE_CONTENT_PREFIX))));
    if (filteredPrefix.Count == 0)
    {
        Console.WriteLine("error: Unrecognized response from server.");
        return;
    }

    List<string> filteredSubstring = new();
    filteredPrefix.ForEach(line => filteredSubstring.Add(line.Substring(0, line.IndexOf('\"'))));

    List<string> originalImageSizeUrl = new();
    foreach (string line in filteredSubstring)
    {
        int index = line.IndexOf("=w");
        if (index >= 0 && index < line.Length)
        {
            var subString = line.Substring(0, index);
            subString += "=w0";
            originalImageSizeUrl.Add(subString);
        }
    }
    if (originalImageSizeUrl.Count == 0)
    {
        Console.WriteLine("error: Unrecognized response from server.");
        return;
    }

    foreach (string line in originalImageSizeUrl)
    {
        Console.WriteLine(line);
    }

} 
catch(Exception ex)
{
    Console.WriteLine("error:" + ex.Message);
}
