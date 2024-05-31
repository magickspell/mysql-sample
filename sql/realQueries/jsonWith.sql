with coss as (
	select
		cows.construction_project_id,
		cows.site_id,
		json_build_object(
			'versionId', cows.version_id,
			'constructionObjectId', cows.construction_object_id,
			'shortName', cows.short_name,
			'fullName', cows.full_name
		) as cows_obj
	from cp.construction_object cows 
),
sitess as (
	select
		sitessws.construction_project_id,
		sitessws.site_id,
		json_build_object(
			'versionId', sitessws .version_id,
			'siteId', sitessws.site_id,
			'shortName', sitessws.short_name,
			'fullName', sitessws.full_name,
			'constructionObjects', json_agg(coss.cows_obj)
		) as sitessws_obj
	from cp.site sitessws
	join coss on sitessws.site_id = coss.site_id
	group by sitessws.construction_project_id, sitessws.site_id, sitessws.version_id, sitessws.short_name, sitessws.full_name 
),
projects as (
	select
		cpws.construction_project_id,
		cpws.contour_id,
		json_build_object(
			'versionId', cpws.version_id,
			'constructionProjectId', cpws.construction_project_id,
			'shortName', cpws.short_name,
			'fullName', cpws.full_name,
			'sites', json_agg(sitess.sitessws_obj)
		) as cpws_obj
	from cp.construction_project cpws 
	join sitess on cpws.construction_project_id = sitess.construction_project_id
	group by cpws.construction_project_id, cpws.contour_id, cpws.version_id, cpws.short_name, cpws.full_name 
)
--select * from projects
select
	c.contour_id AS "contourId",
    c."name",
    json_build_object(
		'projects', json_agg(projects.cpws_obj)	
    )
from cp.contours c 
join projects on c.contour_id = projects.contour_id
group by c.contour_id
;