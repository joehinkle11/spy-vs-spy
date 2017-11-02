import Foundation
import CoreLocation

//Create Building Class
class building
{
    //Variables
    //Create buildings array of Circular Regions
    var buildings = [CLCircularRegion]()
    
    init()
    {
        /*WOODWARD BUILDING*/
        //Region 1
        let woodward_center1 = CLLocationCoordinate2DMake(35.306738480027121, -80.735401120112030)
        let woodward_region1 = CLCircularRegion(center: woodward_center1, radius: 25, identifier: "Woodward1")
        
        //Region 2
        let woodward_center2 = CLLocationCoordinate2DMake(35.307270227964324, -80.735824070964324)
        let woodward_region2 = CLCircularRegion(center: woodward_center2, radius: 25, identifier: "Woodward2")
        
        //Region 3
        let woodward_center3 = CLLocationCoordinate2DMake(35.307127522766805, -80.736677051528730)
        let woodward_region3 = CLCircularRegion(center: woodward_center3, radius: 25, identifier: "Woodward3")
        
        //Region 4
        let woodward_center4 = CLLocationCoordinate2DMake(35.307362470808727, -80.735537158400504)
        let woodward_region4 = CLCircularRegion(center: woodward_center4, radius: 25, identifier: "Woodward4")
        
        //Region 4
        let woodward_center5 = CLLocationCoordinate2DMake(35.305582483104445, -80.736036853121490)
        let woodward_region5 = CLCircularRegion(center: woodward_center5, radius: 25, identifier: "Woodward5")
        
        //Append all to array
        buildings.append(woodward_region1)
        buildings.append(woodward_region2)
        buildings.append(woodward_region3)
        buildings.append(woodward_region4)
        buildings.append(woodward_region5)
        
        //Print message to console
        print("Created Woodward")
        
        /*COED*/
        //Region 1
        let coed_center1 = CLLocationCoordinate2DMake(35.307648261185712, -80.733926306846982)
        let coed_region1 = CLCircularRegion(center: coed_center1, radius: 50, identifier: "College of Education1")
        
        //Region 2
        let coed_center2 = CLLocationCoordinate2DMake(35.307402285189291, -80.733857970119843)
        let coed_region2 = CLCircularRegion(center: coed_center2, radius: 50, identifier: "College of Education2")
        
        //Append all to array
        buildings.append(coed_region1)
        buildings.append(coed_region2)
        
        //Print message to console
        print("Created COED")

        /*APARTMENT*/ //Testing purposes only
        let apartment_center = CLLocationCoordinate2DMake(35.292231878298608, -80.729466648847534)
        let apartment_region = CLCircularRegion(center: apartment_center, radius: 20, identifier: "Apartment")
        
        //Append to array
        buildings.append(apartment_region)
        
        //Print message to console
        print("Created Apartment")
    }
}
