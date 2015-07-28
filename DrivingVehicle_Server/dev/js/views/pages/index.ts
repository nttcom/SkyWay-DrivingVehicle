/// <reference path="../../typings/tsd.d.ts" />

module Vehicle {
    export class Index{
        private _peer: PeerJs.Peer;
        private _APIkey: string = "yourAPIkey";

        constructor() {
            this._peer = new Peer({
                key: this._APIkey
            });
        }

        listAllPeers(callback: (items: Array<string>)=>void){
            this._peer.listAllPeers((items)=>{
                var peerIds: Array<string> = [];

                //only peerIDs that contain the substring "Romo" or "Double"
                _.each(items, (element, index, array)=>{
                    if (element.indexOf('Romo') === 0) {
                        peerIds.push(element);
                    } else if (element.indexOf('Double') === 0) {
                        peerIds.push(element);
                    }
                });

                callback(peerIds);
            });
        }

        listItems(callback: (items: string)=>void){
            this.listAllPeers((items)=>{
                var tag = "";

                //create table
                _.each(items, (element, index, array)=>{
                    tag += "<table class='peer-list'><tr><th>"+ this._peerURLDecode(element) +"</th>";
                    var allLink = '<td class="PConly"><a href="/all.html?peerId=' + element + '"><button class="btn btn-success btn-lg">ALL <i class="fa fa-laptop"></i></button></a></td>';
                    var muteLink = '<td class="PConly"><a href="/mute.html?peerId=' + element + '"><button class="btn btn-info btn-lg">ALL (mute) <i class="fa fa-microphone-slash"></i></button></a></td>';
                    var raceLink = '<td class="PConly"><a href="/race.html?peerId=' + element + '"><button class="btn btn-warning btn-lg">Race <i class="fa fa-car"></i></button></a></td>';
                    var androidLink = '<td><a href="/android.html?peerId=' + element + '"><button class="btn btn-danger btn-lg">Android <i class="fa fa-mobile"></i></button></a></td>';
                    tag += allLink + muteLink + androidLink + raceLink + "</tr></table>";
                });

                //if not find any device
                if(tag === ""){
                    tag = '<div class="alert alert-danger" role="alert"><i class="fa fa-bell"> Can\'t find any devices to connect to</i></div>';
                }

                callback(tag);
            });
        }

        private _peerURLDecode(peerId:string): string{
            //We cannot use "%" for peerID, so change "%" to "__" on DrivingVehicle App
            peerId = peerId.replace(/__/g, "%");

            peerId = decodeURI(peerId);
            return peerId;
        }
    }
}
