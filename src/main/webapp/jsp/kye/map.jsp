<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Insert title here</title>

<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
</head>

<body>
	<div class="map-container">
		<div id="map" style="width: 65%; height: 500px;"></div>
		<div id="list-all">
			<h2 style="color: #f3f0d7">가까운서점</h2>
		</div>
	</div>



	<script src="js/bookstoreinfo.js"></script>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a0775458e66dc2a17eed12803ecfa867&libraries=services"></script>
	<script>
      var mapContainer = document.getElementById("map"), // 지도를 표시할 div
        	mapOption = {
          center: new kakao.maps.LatLng(37.56742261797555, 127.0100117859028), // 지도의 중심좌표
          level: 3,
          // 지도의 확대 레벨
        };

      // 지도를 생성합니다
      var map = new kakao.maps.Map(mapContainer, mapOption);

      	if (navigator.geolocation) {
        	// GeoLocation을 이용해서 접속 위치를 얻어옵니다
        	navigator.geolocation.getCurrentPosition(function (position) {
          var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도

          var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
            message = '<div style="padding:5px;">현위치</div>'; // 인포윈도우에 표시될 내용입니다

          // 마커와 인포윈도우를 표시합니다
          displayMarker(locPosition, message);
        });
      } else {
        // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다

        var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),
          message = "geolocation을사용할수 없어요..";

        displayMarker(locPosition, message);
      }

      function displayMarker(locPosition, message) {
        map.setCenter(locPosition);
      }

      // 주소-좌표 변환 객체를 생성합니다
      var geocoder = new kakao.maps.services.Geocoder();
      var overlay;
      // 주소로 좌표를 검색합니다
      list.map((it) => {
        let name = it.store_name;
        let adres = it.adres;
        let sns = it.sns;
        let tel = it.tel_no == null ? "" : it.tel_no;
        let y = it.ydnts;
        let x = it.xcnts;
        let hmpg = it.hmpg_url;

        geocoder.addressSearch(
          it.adres,

          function (result, status) {
            // 정상적으로 검색이 완료됐으면
            if (status === kakao.maps.services.Status.OK) {
              var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

              // 결과값으로 받은 위치를 마커로 표시합니다
              var marker = new kakao.maps.Marker({
                map: map,
                position: coords,
              });
			
             
              var content =
               
            	  sns != null ? 
                	'<div class="wrap">' +
                    '    <div class="info">' +
                    '        <div class="title">' +
                    name +
                    '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' +
                    "        </div>" +
                    '        <div class="body">' +
                    '            <div class="desc">' +
                    '                <div class="ellipsis">' +
                    adres +
                    "</div>" +
                    "                <div><a href=" +
                    sns +
                    ' class="link">SNS</a></div>' +
                    "                <div><a href=" +
                    hmpg +
                    ' class="link">홈페이지</a></div>' +
                    '                <div><a class="ellipsis">' +
                    tel +
                    "</a></div>" +
                    "            </div>" +
                    "            </div>" +
                    "        </div>" +
                    "    </div>" +
                    "</div>"
                  : '<div class="wrap">' +
                    '    <div class="info">' +
                    '        <div class="title">' +
                    name +
                    '        <div class="close" onclick="closeOverlay()" title="닫기"></div>' +
                    "        </div>" +
                    '        <div class="body">' +
                    '            <div class="desc">' +
                    '                <div class="ellipsis">' +
                    adres +
                    "</div>" +
                    '                <div><a class="ellipsis">' +
                    tel +
                    "</a></div>" +
                    "            </div>" +
                    "            </div>" +
                    "        </div>" +
                    "    </div>" +
                    "</div>"

                    
                    
                    
              kakao.maps.event.addListener(marker, "click", function () {
                overlay = new kakao.maps.CustomOverlay({
                  content: content,
                  map: map,
                  position: marker.getPosition(),
                });
                // 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
                overlay.setMap(map);
              });
            }
          }
        );
      });

      function getDistance(lat1, lon1, lat2, lon2, unit) {
        var radlat1 = (Math.PI * lat1) / 180;
        var radlat2 = (Math.PI * lat2) / 180;
        var radlon1 = (Math.PI * lon1) / 180;
        var radlon2 = (Math.PI * lon2) / 180;
        var theta = lon1 - lon2;
        var radtheta = (Math.PI * theta) / 180;
        var dist =
          Math.sin(radlat1) * Math.sin(radlat2) +
          Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
        dist = Math.acos(dist);
        dist = (dist * 180) / Math.PI;
        dist = dist * 60 * 1.1515;

        if (unit == "K") {
          dist = dist * 1.609344;
        }
        if (unit == "N") {
          dist = dist * 0.8684;
        }
        return dist;
      }

      navigator.geolocation.getCurrentPosition(function (position) {
        var lat = position.coords.latitude, // 위도
          lon = position.coords.longitude; // 경도
        console.log("latitude", lat);
        console.log("longitude", lon);

        for (let i = 0; i < list.length; i++) {
          let distance = getDistance(
            lat,
            lon,
            list[i].xcnts,
            list[i].ydnts,
            "K"
          );
          list[i].distance = distance;
        }

        const newList = list.sort(function (a, b) {
          if (a.distance > b.distance) {
            return 1;
          }
          if (a.distance < b.distance) {
            return -1;
          }
          return 0;
        });
 

       for(let i = 0; i < newList.length; i++) {
     	   let store_name= newList[i].store_name;
    	   let tel_no = newList[i].tel_no == null ? "" : newList[i].tel_no; 
    	   let adres2=newList[i].adres;
    	   let adres=newList[i].adres;
    	   let sns= newList[i].sns;
    	   let hmpg=newList[i].hmpg_url;
    	        
         $("#list-all").append(
        		 sns&&hmpg != null ? 
                '<div id="newList"><ol><li>'+store_name+'</li><li>'+tel_no+'</li>'+
                '<li>'+adres2+'</li><li><a href=' +
                sns +
                ' class="link">SNS</a><a href='+hmpg+
                ' class="link">홈페이지</a></li></ol></div>'
                
                : '<div id="newList"><ol><li>'+store_name+'</li><li>'+tel_no+'</li>'+
                '<li>'+adres+'</li></ol></div>'
                
        
                
             )
  
       }
     
     
        
        
        
      
       
   
      }); 

      // 커스텀 오버레이를 닫기 위해 호출되는 함수입니다
      function closeOverlay() {
        overlay.setMap(null);
      }
    </script>
</body>
</html>