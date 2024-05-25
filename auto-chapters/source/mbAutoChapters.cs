using System;
using System.Text;
using System.Xml;

namespace mbAutoChapters
{
    class Program
    {
        const int _framesPerSecond = 25;

        static void Main(string[] args)
        {
            // Check we have the right number of arguments
            if (args.Length != 3)
            {
                return;
            }

            // Get each argument
            int frames = int.Parse(args[0]);
            string fileType = args[1];
            string filename = args[2];

            // Define chapter Length in Frames
            decimal chapterLengthInFrames = 7500;

            if (fileType == "audio")
            {
                chapterLengthInFrames = 1500;
            }

            // Calculate how many chapters there will be
            decimal numberOfChapters = frames / chapterLengthInFrames;

            if (numberOfChapters > 99)
            {
                // Too many chapters
				// Alter Chapter length to fit into 100 chapters
                chapterLengthInFrames = (decimal)frames / 99;
                numberOfChapters = 99;
            }

            // Determine whether the ultimate chapter is too small
			// cant habe <50 frames and should just be appended
			// to the penultimate chapter
            decimal numberOfChaptersDecimal = numberOfChapters - Math.Truncate(numberOfChapters);

            if (numberOfChaptersDecimal != 0 && numberOfChaptersDecimal * chapterLengthInFrames < 50)
            {
                numberOfChapters -= 1;
            }

            // Define the XML document
            XmlDocument outputDocument = new XmlDocument();

            XmlDeclaration declaration = (XmlDeclaration)outputDocument.AppendChild(outputDocument.CreateXmlDeclaration("1.0", "utf-8", null));
            XmlElement contentAgentElement = (XmlElement)outputDocument.AppendChild(outputDocument.CreateElement("CONTENTAGENT"));
            XmlElement clipMetaDataElement = (XmlElement)contentAgentElement.AppendChild(outputDocument.CreateElement("CLIPMETADATA"));
            XmlElement metaDataCollectionElement = (XmlElement)clipMetaDataElement.AppendChild(outputDocument.CreateElement("METADATACOLLECTION"));
            XmlElement metaDataElement = (XmlElement)metaDataCollectionElement.AppendChild(outputDocument.CreateElement("METADATA"));
            metaDataElement.SetAttribute("groupname", "Chapters");
            metaDataElement.SetAttribute("copyinc", "false");

            // Loop through the chapters
            for (int i = 0; i < numberOfChapters; ++i)
            {
                // Define chapter number in a friendly format
                string chapterNumber = i.ToString("D2");

                // Calculate Chapter start point in frames and seconds
                decimal chapterStartFrame = i * chapterLengthInFrames;
                decimal chapterStartSeconds = chapterStartFrame / _framesPerSecond;

                // Determine hh, mm, ss, and ff based on chapter start point
                decimal hhDecimal = Math.Floor(chapterStartSeconds / 3600);
                string hh = hhDecimal < 10 ? $"0{hhDecimal.ToString()}" : hhDecimal.ToString();

                decimal mmDecimal = Math.Floor(chapterStartSeconds % 3600 / 60);
                string mm = mmDecimal < 10 ? $"0{mmDecimal.ToString()}" : mmDecimal.ToString();

                decimal ssDecimal = Math.Floor(chapterStartSeconds % 60);
                string ss = ssDecimal < 10 ? $"0{ssDecimal.ToString()}" : ssDecimal.ToString();

                decimal ffDecimal = Math.Floor(chapterStartFrame % _framesPerSecond);
                string ff = ffDecimal < 10 ? $"0{ffDecimal.ToString()}" : ffDecimal.ToString();

                // Add chapter elements to XML object
                XmlElement timecodeElement = (XmlElement)metaDataElement.AppendChild(outputDocument.CreateElement("DATA"));
                timecodeElement.SetAttribute("name", $"Chapter_{chapterNumber}_Timecode");
                timecodeElement.SetAttribute("displayname", $"Chapter {chapterNumber} Timecode");
                timecodeElement.SetAttribute("type", "TextField");
                timecodeElement.SetAttribute("value", $"{hh}:{mm}:{ss}:{ff}");

                XmlElement captionElement = (XmlElement)metaDataElement.AppendChild(outputDocument.CreateElement("DATA"));
                captionElement.SetAttribute("name", $"Chapter_{chapterNumber}_Caption");
                captionElement.SetAttribute("displayname", $"Chapter {chapterNumber} Caption");
                captionElement.SetAttribute("type", "TextField");
                captionElement.SetAttribute("value", string.Empty);
            }

            // Save XML file
            outputDocument.Save($"{filename}_chapters.xml");
            //outputDocument.Save(Console.Out);
        }
    }
}
